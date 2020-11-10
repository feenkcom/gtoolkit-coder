"
! Source coder
I am a coder for the source code. I know about the ==sourceCode== (${class:GtCoderSourceCode}$) and ==completionStrategy== (${class:GtCompletionStrategy}$).
!! Actions
All source coders know about basic actions such as code evaluation (==do it all, do it and go, do it selection and go==) or different browsing abilities. Those actions can only be executed in a presence of a text editor UI element that is passed as an argument. It is required to provide a text editor element in order to get information about cursor position or current selection, in addition to being able to have a UI context to notify user or provide her with a feedback of the executed action. All actions are always performed on the current source code text (expanded/collapsed state is not taken into account).
!! Add-ons
The source coder extends the addons (${class:GtCoderAddOns}$) with extra stylers (see ${class:GtSourceCoderAddOns}$) that allows users to add extra contextual information within the text editor via text attributes.
!! Implementation details
It is important to notice that I do not directly reference a text editor and I should not store any UI related information such as cursor position or selection.


"
Class {
	#name : #GtSourceCoder,
	#superclass : #GtCoderModel,
	#instVars : [
		'sourceCode',
		'completionStrategy',
		'astCache',
		'astMonitor',
		'astCommand'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'api - addons' }
GtSourceCoder >> addCopyCutPasteContextMenuAddOnsTo: coderAddOns [
	<gtCoderContextMenuAddOns: 10>
	coderAddOns
		addContextMenuItem: 'Cut'
			action: [ :anEditorElement | anEditorElement editor cutSelected ];
		addContextMenuItem: 'Copy'
			action: [ :anEditorElement | anEditorElement editor copySelected ];
		addContextMenuItem: 'Paste'
			action: [ :anEditorElement | anEditorElement editor paste ]
]

{ #category : #'private - addons' }
GtSourceCoder >> addOnChanged: aSymbol [
	aSymbol = #stylers
		ifTrue: [ self notifyStylersUpdated ].
	super addOnChanged: aSymbol
]

{ #category : #'private - addons' }
GtSourceCoder >> addOnsClass [
	^ GtSourceCoderAddOns
]

{ #category : #'private - refactorings' }
GtSourceCoder >> addRefactoringChangesPreview: aRefactoring at: position [
	self
		addRefactoringChangesPreview: aRefactoring
		at: position
		whenComplete: nil
]

{ #category : #'private - ast' }
GtSourceCoder >> astCache [
	^ astMonitor critical: [ astCache ]
]

{ #category : #'private - ast' }
GtSourceCoder >> astCache: anAssociation [
	astMonitor critical: [ astCache := anAssociation ].
	self onAstChanged
]

{ #category : #private }
GtSourceCoder >> behavior [
	"Return a Behavior whose instance the object is"
	<return: #Behavior>
	
	^ self object class
]

{ #category : #'api - actions' }
GtSourceCoder >> browseImplementorsFrom: anEditorElement [
	| symbol |

	symbol := (self selectedSourceInEditor: anEditorElement editor)
		ifEmpty: [ self selectorAtCursorInEditor: anEditorElement editor ]
		ifNotEmpty: [ :currentSelection | self extractSelectorFromString: currentSelection ].

	symbol isNil
		ifTrue: [ ^ self ].

	anEditorElement phlow spawnObject: (GtSearchImplementorsFilter selector: symbol)
]

{ #category : #'api - actions' }
GtSourceCoder >> browseReferencesFrom: anEditorElement [
	| filter |

	filter := (self selectedSourceInEditor: anEditorElement editor)
		ifEmpty: [ self referencesFilterAtCursorIn: anEditorElement editor ]
		ifNotEmpty: [ :currentSelection | self extractReferencesFilterFromString: currentSelection ].

	filter isNil
		ifTrue: [ ^ self ].

	anEditorElement phlow spawnObject: filter
]

{ #category : #'api - actions examples' }
GtSourceCoder >> canExecuteExample [
	<return: #Boolean>
	^ false
]

{ #category : #private }
GtSourceCoder >> classOrMetaClass [
	self
		deprecated: 'Use #behavior instead.'
		transformWith: '`@receiver classOrMetaClass' -> '`@receiver behavior'.
		
	^ self behavior
]

{ #category : #'private - text' }
GtSourceCoder >> clearPreviousEvaluationsInText: aBlText [
	"Remove all attributes that may be related to the code evaluation in a given ${class:BlText}$ instance"
	| theEvaluationAttributeTypes |
	
	theEvaluationAttributeTypes :=
		{
			GtPlaygroundEvaluatedCodeHighlightedAttribute.
			GtPlaygroundEvaluatedCodeButtonAttribute.
			GtCoderPrintStringAttribute.
			GtPlaygroundDebugExceptionButtonAttribute.
			GtSourceCoderErrorAttribute
		}.

	aBlText clearAttributes: [ :eachAttribute |
		theEvaluationAttributeTypes anySatisfy: [ :eachClass | eachAttribute isKindOf: eachClass ] ]
]

{ #category : #'private - text' }
GtSourceCoder >> clearSyntaxErrors [
	self sourceTextDo: [ :aSourceText | self clearSyntaxErrorsInText: aSourceText ]
]

{ #category : #'private - text' }
GtSourceCoder >> clearSyntaxErrorsInText: aBlText [
	"Remove all text attributes that may be related to the syntax errors"

	aBlText clearAttributes: [ :eachAttribute | eachAttribute isKindOf: GtSourceCoderErrorAttribute ]
]

{ #category : #'api - text' }
GtSourceCoder >> collapsedText [
	<return: #BlText>

	^ self sourceCode collapsedText
]

{ #category : #private }
GtSourceCoder >> compile: aStream for: anObject in: evalContext withRequestor: requestor [
	| methodClass |
	methodClass := evalContext
		ifNil: [ anObject class ]
		ifNotNil: [ evalContext methodClass ].
	^self class compiler
		source: aStream;
		class: methodClass;
		context: evalContext;
		requestor: requestor;
		noPattern: true;
		failBlock: [ ^ nil ];
		compile
]

{ #category : #'api - accessing' }
GtSourceCoder >> completionStrategy [
	<return: #GtCompletionStrategy>

	^ completionStrategy
		ifNil: [ completionStrategy := self newCompletionStrategy ]
]

{ #category : #'api - accessing' }
GtSourceCoder >> completionStrategy: aGtCompletionStrategy [
	completionStrategy := aGtCompletionStrategy
]

{ #category : #'api - text' }
GtSourceCoder >> currentSourceString [
	"Return a String representation of the current source text"
	<return: #String>

	^ self sourceCode sourceString
]

{ #category : #'api - text' }
GtSourceCoder >> currentSourceString: aString [
	"Set a new source text"
	
	self sourceCode currentSourceString: aString
]

{ #category : #private }
GtSourceCoder >> cursorPositionIn: aBrTextEditor do: aBlock [
	aBrTextEditor cursors do: [ :each | ^ aBlock value: each position ]
]

{ #category : #'private - actions' }
GtSourceCoder >> debug: aCompiledMethod receiver: anObject in: evalContext [
	| guineaPig context debugSession |
	guineaPig := [ aCompiledMethod
		valueWithReceiver: anObject
		arguments: (evalContext ifNil: [ #() ] ifNotNil: [ {evalContext} ]) ]
		newProcess.
	context := guineaPig suspendedContext.
	
	debugSession := guineaPig newDebugSessionNamed: 'debug it' startedAt: context.
	debugSession stepIntoUntil: [:currentContext | 
		currentContext method == aCompiledMethod ].
	
	Smalltalk tools debugger openOn: debugSession withFullView: true.
]

{ #category : #'api - actions' }
GtSourceCoder >> debugSelectionFrom: anEditorElement [
	^ anEditorElement editor hasSelection
		ifTrue: [ self
				debugSource: (self selectedSourceInEditor: anEditorElement editor)
				from: anEditorElement ]
		ifFalse: [ self debugSource: self currentSourceString from: anEditorElement ]
]

{ #category : #'private - actions' }
GtSourceCoder >> debugSource: aString from: anEditorElement [
	| currentReceiver currentContext method |

	self clearPreviousEvaluationsInText: anEditorElement editor text.

	currentReceiver := self object.
	currentContext := self context.

	method := self 
		compile: aString 
		for: currentReceiver 
		in: currentContext
		withRequestor: (self requesterForEditor: anEditorElement editor).

	method
		ifNotNil: [ self debug: method receiver: currentReceiver in: currentContext ]
]

{ #category : #private }
GtSourceCoder >> defaultTextAttributes [
	^ {(BlFontFamilyAttribute named: 'Source Code Pro') beNotOverwritableByStyler.
	(BlFontGenericFamilyAttribute monospace) beNotOverwritableByStyler.
	(BlFontSizeAttribute size: 14) beNotOverwritableByStyler}
]

{ #category : #private }
GtSourceCoder >> disabledTextAttributes [
	^ {(BlTextForegroundAttribute paint: BrGlamorousColors disabledButtonTextColor)}
]

{ #category : #'api - actions' }
GtSourceCoder >> discardChanges [
	"Discard not-accepted changes."

	self isModified
		ifFalse: [ ^ self ].

	self sourceCode resetCollapsedText.
	self sourceCode resetSourceText.

	self sourceChanged.
	self textModified
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAllFrom: anEditorElement [
	^ self
		evaluateSource: self currentSourceString
		in: anEditorElement
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAndGoAllFrom: anEditorElement [
	| aSource aValue |

	aSource := self currentSourceString.
	aValue := self evaluateSource: aSource in: anEditorElement.
	aValue == self
		ifTrue: [ ^ self ].
	
	anEditorElement phlow 
		spawnObject: aValue
		withDestination: self spawnDestination
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAndGoSelectionFrom: anEditorElement [
	| source value |
	source := self selectedSourceInEditor: anEditorElement editor.
	source
		ifEmpty: [ ^ self ].
	
	value := self evaluateSource: source in: anEditorElement.
	
	value == self
		ifTrue: [ ^ self ].
	
	anEditorElement phlow 
		spawnObject: value
		withDestination: self spawnDestination
]

{ #category : #'api - actions' }
GtSourceCoder >> doItAndGoSelectionOrAllFrom: anEditorElement [
	anEditorElement editor hasSelection
		ifTrue: [ self doItAndGoSelectionFrom: anEditorElement ] 
		ifFalse: [ self doItAndGoAllFrom: anEditorElement ]
]

{ #category : #'api - actions' }
GtSourceCoder >> doItSelectionFrom: anEditorElement [
	"Evaluate a selected piece of source code and return a result.
	I am also able to evaluate an empty or only consisting of whitespace
	source code in which case the result is nil"
	<return: #Object>

	^ self
		evaluateSource: (self selectedSourceInEditor: anEditorElement editor)
		in: anEditorElement
]

{ #category : #'api - actions' }
GtSourceCoder >> doItSelectionOrAllFrom: anEditorElement [
	^ anEditorElement editor hasSelection 
		ifTrue: [ self doItSelectionFrom: anEditorElement ] 
		ifFalse: [ self doItAllFrom: anEditorElement ]
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluateBlock: aBlock showPrintString: aBoolean in: anEditorElement [
	| aResult wasErrorAlreadySignaled |
	
	self clearPreviousEvaluationsInText: anEditorElement editor text.

	wasErrorAlreadySignaled := false.
	aResult := aBlock on: Error do: [ :anError |
		self resetASTCache.
		wasErrorAlreadySignaled 
			ifTrue: [ 
				"Continue the handling of this exception. This will open a debugger 
				if the error is not caught elsewhere."
				anError pass ]
			ifFalse: [
				wasErrorAlreadySignaled := true.
				anError resignalAs:
					(GtCoderEvaluationUnhandledError new
						exception: anError;
						sourceCoder: self;
						selection: anEditorElement selection) ].
		"The process will be terminated. Return nil in case there is some error whil opening the debugger
		that prevents the debugger from opening and does not kill the process."
		^ nil ].
		
	self resetASTCache.
	self announce: (GtCoderEvaluationAnnouncement forCoder: self value: aResult isException: false).
	anEditorElement editor styleTextAndAfterDo: [
		self styleResult: aResult showPrintString: aBoolean in: anEditorElement ].
	^ aResult
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluateSource: aString in: anEditorElement [
	^ self
		evaluateSource: aString
		showPrintString: false
		in: anEditorElement
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluateSource: aString showPrintString: aBoolean in: anEditorElement [
	^ self
		evaluateBlock: [ self behavior compiler
				source: aString;
				receiver: self object;
				context: self context;
				requestor:
					((self evaluationRequesterForEditor: anEditorElement editor)
						source: aString);
				failBlock: [ ^ self flag: 'insert error adornment' ];
				evaluate ]
		showPrintString: aBoolean
		in: anEditorElement
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluationRequesterForEditor: anEditorElement [
	^ GtSourceCoderEvaluationRequester on: self editor: anEditorElement
]

{ #category : #private }
GtSourceCoder >> extractReferencesFilterFromString: selectedString [
	| node |
	node := GtPharoParser
		parseWithErrors: selectedString
		startingAt: GtPharoParser startingStateForStatement.
	[ node isNil ]
		whileFalse: [ (node isKindOf: GtPharoVariableNode)
				ifTrue: [ | binding |
					binding := self behavior bindingOf: node name source.
					^ binding
						ifNil: [ self referencesFilterForSymbol: node name source asSymbol ]
						ifNotNil: [ self referencesFilterForSymbol: binding ] ].
			(node isKindOf: GtPharoSymbolLiteralNode)
				ifTrue: [ ^ self referencesFilterForSymbol: node asSymbol ].
			(node isKindOf: GtPharoMessageSendNode)
				ifTrue: [ node := node message ].
			(node isKindOf: GtPharoMessageNode)
				ifTrue: [ ^ self referencesFilterForSymbol: node selector ].
			node := node parent ].
	^ nil
]

{ #category : #private }
GtSourceCoder >> extractSelectorFromString: aString [
	| node |
	node := GtPharoParser 
		parseWithErrors: aString
		startingAt: GtPharoParser startingStateForStatement.
	[ node isNil ]
		whileFalse: [ 
			(node isKindOf: GtPharoVariableNode)
				ifTrue: [ ^ node name source asSymbol ].
			(node isKindOf: GtPharoSymbolLiteralNode)
				ifTrue: [ ^ node asSymbol ].
			(node isKindOf: GtPharoMessageSendNode)
				ifTrue: [ node := node message ].
			(node isKindOf: GtPharoMessageNode)
				ifTrue: [ ^ node selector ].
			node := node parent ].
	^ nil
]

{ #category : #'gt-extensions' }
GtSourceCoder >> gtViewStylersFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewStylersFor: aView ]
]

{ #category : #testing }
GtSourceCoder >> hasObjectAttribute [
	<return: #Boolean>
	self 
		attributeNamed: #object 
		ifAbsent: [ ^ false ].

	^ true
]

{ #category : #initialize }
GtSourceCoder >> initialize [
	super initialize.

	astMonitor := Monitor new.
	self reset
]

{ #category : #initialize }
GtSourceCoder >> initializeAddOns [
	super initializeAddOns.
	
	addOns addStyler: BrRBTextStyler new.
	
	addOns clearChanges
]

{ #category : #initialize }
GtSourceCoder >> initializeShortcuts [

	addOns
		addShortcut: GtSourceCoderBrowseImplementorsShortcut new;
		addShortcut: GtSourceCoderBrowseReferencesShortcut new;
		addShortcut: GtSourceCoderBrowseBehaviorShortcut new;
		addShortcut: GtSourceCoderDiscardChangesShortcut new
]

{ #category : #testing }
GtSourceCoder >> isForMethod [
	^ false
]

{ #category : #testing }
GtSourceCoder >> isModified [
	<return: #Boolean>

	^ self sourceCode isModified
]

{ #category : #private }
GtSourceCoder >> newCompletionStrategy [
	^ GtPharoCompletionStrategy new
		classOrMetaClass: self behavior;
		yourself
]

{ #category : #'private - ast' }
GtSourceCoder >> newRbAST: aString [
	| ast |
	ast := self parseExpression: aString requestor: nil.
	ast doSemanticAnalysis.
	^ ast
]

{ #category : #private }
GtSourceCoder >> newSourceStylerFrom: anEditorElement [
	| anAddOnsCopy |
	anAddOnsCopy := self addOns stylers copy.
	anAddOnsCopy do: [ :eachAddOn | 
		eachAddOn editorElement: anEditorElement ].
	^ (GtSourceCoderTextStyler forCoder: self)
		stylers: anAddOnsCopy;
		yourself
]

{ #category : #private }
GtSourceCoder >> nodeAtCursorIn: aBrTextEditor [
	self
		cursorPositionIn: aBrTextEditor do: [ :position | 
			[ | ast innerNode |
			ast := self sourceAst.
			ast
				withAllNodesDo: [ :node | 
					(position between: node startPosition and: node stopPosition)
						ifTrue: [ innerNode := node ] ].
			^ innerNode ]
				on: Error
				do: [ :ex | ex return ] ].
	^ nil
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyParseError: aString at: anInteger [
	self announce: (GtCoderParseError new
		coder: self;
		errorMessage: aString;
		location: anInteger)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifySourceChangedWith: anUpdateStragegy [
	"Notify the text editor that it should update the text (for example due to refactoring changes)"
	
	self announce: (GtCoderSourceCodeChanged new 
		updateStragegy: anUpdateStragegy;
		coder: self)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyStylersUpdated [
	"Is sent when AddOn stylers changed. It also means that the text editor should restyle the text"

	self announce: (GtCoderStylerChanged new
		coder: self;
		stylers: self addOns stylers copy)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyTextModified [	
	self announce: (GtCoderSourceTextModified new coder: self)
]

{ #category : #'api - accessing' }
GtSourceCoder >> object [
	"Return an object in the context of which the source code is modified (may influence self binding)
	or nil otherwise of not set"
	<return: #Object or: nil>

	^ self
		attributeNamed: #object
		ifAbsent: [ nil ]
]

{ #category : #'api - accessing' }
GtSourceCoder >> object: anObject [
	"Set an object in the context of which the source code should be modified (may influence self binding)"

	anObject 
		ifNil: [ self removeAttributeNamed: #object ]
		ifNotNil: [ self attributeNamed: #object put: anObject ]
]

{ #category : #'private - ast' }
GtSourceCoder >> onAstChanged [
]

{ #category : #accessing }
GtSourceCoder >> package [
	^ self attributeNamed: #package
]

{ #category : #accessing }
GtSourceCoder >> packageTag [
	^ self attributeNamed: #packageTag
]

{ #category : #private }
GtSourceCoder >> parse: aString asExpression: isExpression requestor: aRequestor [
	^ (self behavior ifNil: [ UndefinedObject ]) compiler
		source: aString;
		noPattern: isExpression;
		options: #(+ optionParseErrors + optionSkipSemanticWarnings);
		requestor: aRequestor;
		parse
]

{ #category : #private }
GtSourceCoder >> parseExpression: aString requestor: aRequestor [
	^ self parse: aString asExpression: true requestor: aRequestor
]

{ #category : #private }
GtSourceCoder >> parseMethod: aString [
	^ self parse: aString asExpression: false requestor: nil
]

{ #category : #private }
GtSourceCoder >> parserStartingState [
	^ GtPharoParser startingStateForMethodSequence
]

{ #category : #'private - ast' }
GtSourceCoder >> pharoBehaviorInSelectionOrAtCursorInEditor: aTextEditor ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a Pharo class within current selected source text or at the cursor position in a given text editor
	and evaluate a found block with the found class as an argument if such class was found or none block otherwise. Return the result"
	<return: #Object>
	^ self
		variableNodeInSelectionOrAtCursorInEditor: aTextEditor
		ifFound: [ :aVariableNode |
			| aVariableName aBehavior |
			
			aVariableName := aVariableNode name value asSymbol.
			
			aBehavior := Smalltalk globals
				at: aVariableName
				ifAbsent: [ ^ aNoneBlock value ].

			aBehavior isBehavior
				ifFalse: [ ^ aNoneBlock value ].
				
			aFoundBlock value: aBehavior ]
		ifNone: aNoneBlock
]

{ #category : #private }
GtSourceCoder >> pragmasNamed: aSymbol inHierarchy: aClass [
	| actions |
	actions := OrderedCollection new.
	aClass withAllSuperclassesDo: [ :each | actions addAll: (Pragma allNamed: aSymbol in: each) ].
	actions sort: [ :a :b | a arguments first < b arguments first ].
	^ actions
]

{ #category : #'api - actions' }
GtSourceCoder >> printItAllFrom: anEditorElement [
	^ self
		evaluateSource: self currentSourceString
		showPrintString: true
		in: anEditorElement
]

{ #category : #'api - actions' }
GtSourceCoder >> printItSelectionFrom: anEditorElement [
	^ self
		evaluateSource: (self selectedSourceInEditor: anEditorElement editor)
		showPrintString: true
		in: anEditorElement
]

{ #category : #'api - actions' }
GtSourceCoder >> printItSelectionOrAllFrom: anEditorElement [
	^ anEditorElement editor hasSelection 
		ifTrue: [ self printItSelectionFrom: anEditorElement ] 
		ifFalse: [ self printItAllFrom: anEditorElement ]
]

{ #category : #'private - ast' }
GtSourceCoder >> rbAST [
	| source |

	"The AST should be built out of the `characters` of the source text.
	This is needed to support `crlf` and logical items
	see https://github.com/feenkcom/gtoolkit/issues/593"
	source := self currentSourceString.
	astCache key = source
		ifTrue: [ ^ astCache value ].
	^ [ 
		self astCache: source -> (self newRbAST: source).
		astCache value ]
	on: Error
	do: [ :ex | ex return: nil ]
]

{ #category : #'private - ast' }
GtSourceCoder >> rbASTAsyncDo: aBlock [

	astMonitor critical: [ 
		| aCommand astComputationCommand |
		astCommand ifNotNil: #terminate.

		astComputationCommand := [
			| source currentAstCache |
			"The AST should be built out of the `characters` of the source text.
			This is needed to support `crlf` and logical items
			see https://github.com/feenkcom/gtoolkit/issues/593"
			source := self sourceText copy characters asString.
			currentAstCache := self astCache.

			currentAstCache key = source
				ifTrue: [ currentAstCache ]
				ifFalse: [
					[ source -> (self newRbAST: source) ]
						on: Error
						do: [ :ex | ex return: nil ] ].

		] asBlTktTerminableCommand asBlTktLoggingCommand.
		astComputationCommand name: 'Coder ast computation'.
		
		astCommand := aCommand := BlTaskAtPostponedTerminableFuture new.
		aCommand
			command: astComputationCommand;
			onSuccessDo:  [ :aResult | 
				(aCommand == astCommand and: [ aResult notNil ])
					ifTrue: [
						self astCache: aResult.
						aBlock value: aResult ] ];
			onFailureDo: [ :anException | "handle error here" ];
			pool: BlTktWorkerProvider coderPool;
			scheduledTime: BlTime real now + 100 milliSeconds.
		BlTaskAtQueue default schedule: astCommand.
	
	 ].
]

{ #category : #private }
GtSourceCoder >> rbNodeAt: aTextIndex [
	| ast node |

	ast := self rbAST.
	ast ifNil: [ ^ nil ].

	node := nil.
	ast
		nodesDo: [ :each | 
			(aTextIndex between: each start and: each stop)
				ifTrue: [ (node isNil
						or: [ node sourceInterval size > each sourceInterval size ])
						ifTrue: [ node := each ] ] ].
	^ node
]

{ #category : #private }
GtSourceCoder >> rbNodeAtCursor: editorElement [
	| editor ast position node |
	editor := editorElement editor.
	editor cursors cursorsCount = 1
		ifFalse: [ ^ nil ].
	ast := self rbAST.
	ast isNil
		ifTrue: [ ^ nil ].
	position := editor cursors first position.
	ast
		nodesDo: [ :each | 
			(position between: each start and: each stop)
				ifTrue: [ (node isNil
						or: [ node sourceInterval size > each sourceInterval size ])
						ifTrue: [ node := each ] ] ].
	^ node
]

{ #category : #private }
GtSourceCoder >> referencesFilterAtCursorIn: aBrTextEditor [
	| node |
	node := self nodeAtCursorIn: aBrTextEditor.
	[ node isNil ]
		whileFalse: [ (node isKindOf: GtPharoVariableNode)
				ifTrue: [ ^ self referencesFilterForVariable: node name source ].
			(node isKindOf: GtPharoSymbolLiteralNode)
				ifTrue: [ ^ self referencesFilterForSymbol: node asSymbol ].
			(node isKindOf: GtPharoMessageSendNode)
				ifTrue: [ node := node message ].
			((node isKindOf: GtPharoMessageNode)
				or: [ node isKindOf: GtPharoMethodPatternNode ])
				ifTrue: [ ^ self referencesFilterForSymbol: node selector ].
			node := node parent ].
	^ nil
]

{ #category : #private }
GtSourceCoder >> referencesFilterForSymbol: aSymbol [
	^ GtSearchReferencesFilter literal: aSymbol
]

{ #category : #private }
GtSourceCoder >> referencesFilterForVariable: aString [
	| index binding class |
	index := self classOrMetaClass instVarIndexFor: aString.
	index > 0
		ifTrue: [ class := self classOrMetaClass whichClassDefinesInstVar: aString.
			^ GtSearchInstanceVariableReferenceFilter
				forClassAndSubclasses: class
				andVariable: aString ].
	binding := self classOrMetaClass bindingOf: aString.
	binding notNil
		ifTrue: [ ^ GtSearchReferencesFilter literal: binding ].
	^ nil
]

{ #category : #'api - text' }
GtSourceCoder >> requestStyleSourceText [
	"Request the text editor to restyle the text (for example due to environmental changes)"

	self resetASTCache.
	self announce: (GtCoderStyleTextRequest new coder: self)
]

{ #category : #'api - text' }
GtSourceCoder >> requestStyleSourceTextAndAfterDo: aBlock [
	"Request the text editor to restyle the text (for example due to environmental changes)"

	self resetASTCache.
	self
		announce:
			(GtCoderStyleTextRequest new
				coder: self;
				afterAction: aBlock)
]

{ #category : #'api - text' }
GtSourceCoder >> requestUpdateCollapsedText [
	"Request to update the collapsed text, for example due to changes in the current source text.
	It is not guaranteed that the collapsed text actually changes as for example in the method coder
	opened on a compiled method"

	self sourceCode resetCollapsedText.
	self announce: (GtCoderCollapsedLabelChanged new coder: self)
]

{ #category : #'private - actions' }
GtSourceCoder >> requesterForEditor: aTextEditor [
	^ GtSourceCoderRequester on: self editor: aTextEditor
]

{ #category : #initialize }
GtSourceCoder >> reset [
	self resetASTCache.

	"initialized lazily in #sourceCode"
	sourceCode := nil.
	completionStrategy := nil
]

{ #category : #'private - actions' }
GtSourceCoder >> resetASTCache [
	self astCache: (nil -> nil)
]

{ #category : #'private - text' }
GtSourceCoder >> selectedSourceInEditor: aBrTextEditor [
	<return: #String>

	^ aBrTextEditor selectedText characters asString
]

{ #category : #'private - text' }
GtSourceCoder >> selectedSourceIntervalInEditor: aBrTextEditor [
	<return: #Interval>

	aBrTextEditor selection
		do: [ :eachMonotoneSelection | ^ eachMonotoneSelection from + 1 to: eachMonotoneSelection to ].
	
	"this is an empty interval
	https://github.com/feenkcom/gtoolkit/issues/1352"
	^ 1 to: 0
]

{ #category : #'private - text' }
GtSourceCoder >> selectedSourceIntervalOrAllInEditor: aBrTextEditor [
	<return: #Interval>

	^ (self selectedSourceIntervalInEditor: aBrTextEditor)
		ifEmpty: [ self sourceIntervalInEditor: aBrTextEditor ]
]

{ #category : #'private - ast' }
GtSourceCoder >> selectorAtCursorInEditor: aBrTextEditor [
	<return: #Symbol>

	^ self symbolFor: (self nodeAtCursorIn: aBrTextEditor)
]

{ #category : #'api - accessing' }
GtSourceCoder >> source [
	<return: #String>

	self
		deprecated: 'Use #currentSourceString instead'
		transformWith: '`@receiver source' -> '`@receiver currentSourceString'.
		
	^ self currentSourceString
]

{ #category : #private }
GtSourceCoder >> sourceAst [
	^ GtPharoParser
		parseWithErrors: self currentSourceString
		startingAt: self parserStartingState
]

{ #category : #'event handling' }
GtSourceCoder >> sourceChanged [
	self sourceChangedWith: GtCoderUpdateStragegy new
		makeAsynchronous
]

{ #category : #'event handling' }
GtSourceCoder >> sourceChangedWith: anUpdateStragegy [

	"self flag: #TODO." "is there a better way to clear syntax errors than remove attributes after *every* keystroke?"
	self clearSyntaxErrors.

	self requestUpdateCollapsedText.
	self requestUpdateAddOns.
	
	self notifySourceChangedWith: anUpdateStragegy
]

{ #category : #'api - accessing' }
GtSourceCoder >> sourceCode [
	<return: #GtCoderSourceCode>

	sourceCode ifNil: [ self sourceCode: (GtCoderExplicitSourceCode new source: '') ].
	^ sourceCode
]

{ #category : #'api - accessing' }
GtSourceCoder >> sourceCode: aGtCoderSourceCode [
	"Set the source code of this coder to a given one and notify about the changes"
	
	self 
		sourceCode: aGtCoderSourceCode 
		withStrategy: GtCoderUpdateStragegy new 
			makeAsynchronous
]

{ #category : #'api - accessing' }
GtSourceCoder >> sourceCode: aGtCoderSourceCode withStrategy: anUpdateStragegy [
	"Set the source code of this coder to a given one and notify about the changes"
	
	sourceCode ifNotNil: [ :aPreviousSourceCode | aPreviousSourceCode detachFromCoder: self ].
	sourceCode := aGtCoderSourceCode.
	sourceCode attachToCoder: self.

	self sourceChangedWith: anUpdateStragegy.
	self textModified
]

{ #category : #'api - accessing' }
GtSourceCoder >> sourceCodeSynchronously: aGtCoderSourceCode [
	ContextStackSignal emit.
	self 
		sourceCode: aGtCoderSourceCode 
		withStrategy: GtCoderUpdateStragegy new 
			makeSynchronous
]

{ #category : #'private - text' }
GtSourceCoder >> sourceIntervalInEditor: aBrTextEditor [
	"Return the interval that represents the whole source text (first character to last character)"
	<return: #Interval>

	^ 1 to: aBrTextEditor text size
]

{ #category : #'api - text' }
GtSourceCoder >> sourceText [
	"Return a source text for this coder. The computation of the source text may be expensive, use me with caution.
	If the operation you would like to perform on the source text is optional consider using #sourceTextDo:"
	<return: #BlText>

	^ self sourceCode sourceText
]

{ #category : #'api - text' }
GtSourceCoder >> sourceTextDo: aBlock [
	"Evaluate a given block with my source code text if present"

	^ self sourceCode sourceTextDo: aBlock
]

{ #category : #accessing }
GtSourceCoder >> spawnDestination [
	^ self 
		attributeNamed: #spawnDestination 
		ifAbsent: [ GtPhlowSpawnDesiredDestination defaultDestination ]
]

{ #category : #accessing }
GtSourceCoder >> spawnDestination: aSpawnDestination [
	^ self attributeNamed: #spawnDestination put: aSpawnDestination
]

{ #category : #'private - actions' }
GtSourceCoder >> styleResult: value at: interval showPrintString: aBoolean inText: aBlText [
	aBlText
		attributes:
			{(GtPlaygroundEvaluatedCodeButtonAttribute new 
				result: value;
				coder: self "Pass the coder to get the spawn destination")}
		from: interval last
		to: interval last.
	aBoolean
		ifTrue: [ aBlText
				attributes: {(GtCoderPrintStringAttribute forString: value printString)}
				from: interval last
				to: interval last ].
	aBlText
		attributes:
			{(GtPlaygroundEvaluatedCodeHighlightedAttribute new
				paint: (Color fromHexString: #'90CAF9'))}
		from: interval first
		to: interval last
]

{ #category : #'private - actions' }
GtSourceCoder >> styleResult: value showPrintString: aBoolean in: anEditorElement [
	(self selectedSourceIntervalOrAllInEditor: anEditorElement)
		ifNotEmpty: [ :interval |
			self 
				styleResult: value 
				at: interval 
				showPrintString: aBoolean
				inText: anEditorElement editor text ]
]

{ #category : #'private - text' }
GtSourceCoder >> styleSourceTextFrom: anEditorElement [
	"Immediately request to restyle the source text in a given editor element"

	anEditorElement editor styleText
]

{ #category : #'api - addons' }
GtSourceCoder >> stylers [
	^ self addOns stylers
]

{ #category : #private }
GtSourceCoder >> symbolFor: aNode [
	| current |
	current := aNode.
	[ current notNil ]
		whileTrue: [ (current isKindOf: GtPharoSymbolLiteralNode)
				ifTrue: [ ^ aNode asSymbol ].
			(current isKindOf: GtPharoMessageSendNode)
				ifTrue: [ current := current message ].
			((current isKindOf: GtPharoMessageNode)
				or: [ current isKindOf: GtPharoMethodPatternNode ])
				ifTrue: [ ^ current selector ].
			current := current parent ].
	^ nil
]

{ #category : #'private - addons' }
GtSourceCoder >> terminateAddOnsCommand [
	addOnCommand
		ifNil: [ ^ self ].
	addOnCommand terminate.
	addOnCommand := nil
]

{ #category : #'event handling' }
GtSourceCoder >> textModified [
	"Is sent when source text is modified by the user or due to refactorings"

	self notifyTextModified
]

{ #category : #'api - addons' }
GtSourceCoder >> updateAddOns [
	"Start the update of the addons in a context of a given element"

	addOnMonitor
		critical: [			 
			BlUseAsyncFeatures 
				ifEnabledDo: [ 
					self terminateAddOnsCommand.
					addOnCommand := self updateAddOnsCommand.
					addOnCommand name: 'AddOns: ' , self identityHash printString.
					BlTktWorkerProvider coderPool schedule: addOnCommand ]
				otherwise: [ 
					self updateAddOnsCommand execute ] ]
]

{ #category : #'private - addons' }
GtSourceCoder >> updateAddOnsCommand [
	^ [
		| updatedAddOns pragmas ast |
		ast := self rbAST.
		pragmas := self
			pragmasNamed: #gtAstCoderAddOns:
			inHierarchy: self class.
		updatedAddOns := self addOns copy.
		pragmas
			reverseDo:
				[ :each | self perform: each methodSelector with: ast with: updatedAddOns ].
		addOns := updatedAddOns.
		addOns markAsUpdated.
		updatedAddOns changesDo: [ :each | self addOnChanged: each ].
		updatedAddOns clearChanges
	] asBlTktTerminableCommand
]

{ #category : #'api - addons' }
GtSourceCoder >> updateContextMenuAddOnsFrom: anEditorElement [
	| updatedAddOns pragmas |
	pragmas := self
		pragmasNamed: #gtCoderContextMenuAddOns:
		inHierarchy: self class.
	updatedAddOns := self addOns copy.
	updatedAddOns clearContextMenu.
	pragmas
		do: [ :each | self perform: each methodSelector withEnoughArguments: { updatedAddOns. anEditorElement } ].
	addOns := updatedAddOns.
	updatedAddOns clearChanges
]

{ #category : #private }
GtSourceCoder >> validateSyntax [
	<return: #Boolean>

	[ GtPharoParser
		parse: self currentSourceString
		startingAt: self parserStartingState ]
		on: SmaCCParserError
		do: [ :ex | 
			self notifyParseError: ex messageText at: ex tag position.
			^ false ].
	^ true
]

{ #category : #'private - ast' }
GtSourceCoder >> variableNodeAtCursorInEditor: aTextEditor ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a variable node ${class:GtPharoVariableNode}$ in a given text editor at the cursor position and evaluate a found
	block if such node exists and none block otherwise. Return the result.
	If there are multiple cursors evaluate a none found block because otherwise the result can be ambiguous"

	<return: #Object>
	aTextEditor cursors isSingle
		ifFalse: [ ^ aNoneBlock value ].
	aTextEditor cursors
		do: [ :aCursor | 
			^ self
				variableNodeAtCursorPosition: aCursor position
				ifFound: aFoundBlock
				ifNone: aNoneBlock ].
	^ aNoneBlock value
]

{ #category : #'private - ast' }
GtSourceCoder >> variableNodeAtCursorPosition: aCursorPosition ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a variable node ${class:GtPharoVariableNode}$ at a given cursor position and evaluate a found
	block if such node exists and none block otherwise. Return the result"
	<return: #Object>
	[
		| ast |
		ast := self sourceAst.
		ast
			withAllNodesOfType: GtPharoVariableNode
			do: [ :node | 
				(aCursorPosition between: node startPosition and: node stopPosition)
					ifTrue: [ ^ aFoundBlock value: node ] ]
	]
		on: Error
		do: [ :ex | ex return ].

	^ aNoneBlock value
]

{ #category : #'private - ast' }
GtSourceCoder >> variableNodeInSelectionOrAtCursorInEditor: aTextEditor ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to find a variable node ${class:GtPharoVariableNode}$ in a given text editor within the selected source or at the cursor position
	and evaluate a found block if such node exists and none block otherwise. Return the result.
	If there are multiple cursors evaluate a none found block because otherwise the result can be ambiguous"
	<return: #Object>

	^ (self selectedSourceInEditor:aTextEditor)
		ifEmpty: [
			self
				variableNodeAtCursorInEditor: aTextEditor
				ifFound: aFoundBlock
				ifNone: aNoneBlock ]
		ifNotEmpty: [ :aSelectedString |
			self
				variableNodeInString: aSelectedString
				ifFound: aFoundBlock
				ifNone: aNoneBlock ]
]

{ #category : #'private - ast' }
GtSourceCoder >> variableNodeInString: aString ifFound: aFoundBlock ifNone: aNoneBlock [
	"Try to extract a variable node ${class:GtPharoVariableNode}$ in a given string and evaluate a found block
	if such node was found and a none block otherwise. Return the result."
	<return: #Object>
	| node |

	node := GtPharoParser 
		parseWithErrors: aString
		startingAt: GtPharoParser startingStateForStatement.

	[ node isNil ]
		whileFalse: [ 
			(node isKindOf: GtPharoVariableNode)
				ifTrue: [ ^ aFoundBlock value: node ].
			node := node parent ].

	^ aNoneBlock value
]

{ #category : #elements }
GtSourceCoder >> withoutHeader [
	self coderLook: nil
]
