"
! Source coder
I am a coder for the source code. I know about the ==completionStrategy== (${class:GtCompletionStrategy}$) and the ==sourceText== (${class:BlText}$). The ==sourceText== represents the current source code which is being edited by the user through a UI text editor which is opened on my ==sourceText==. It means that at any time the value of ==sourceText== may be different from the original source code, for example a source code of a method.

!! Actions
All source coders know about basic actions such as code evaluation (==do it all, do it and go, do it selection and go==). Those actions can only be executed in a presence of a text editor UI element that is passed as an argument. It is required to provide a text editor element in order to get information about cursor position or current selection, in addition to being able to have a UI context to notify user or provide her with a feedback of the executed action. All actions are always performed on the current source code text (expanded/collapsed state is not taken into account).

${method:GtSourceCoder>>#browseClass:}$ tries to browse an existing class based on the current selection and cursor position in the text editor.

!! Add ons
Q: Where are they used and where are they actually added to the UI?

!! Accessors
${method:GtSourceCoder>>#source}$ returns a ${class:String}$ snapshot of the current source code text (${method:GtSourceCoder>>#sourceText}$) that is being modified by the user.
${method:GtSourceCoder>>#selectedSourceIn:}$ return a ${class:String}$ snapshot of the currently selected source text (${method:GtSourceCoder>>#sourceText}$). Returns empty string if the source code is empty or if there is no selection.

!! Implementation details
It is important to notice that I do not directly reference a text editor and I should not store any UI related information such as cursor position or selection.


"
Class {
	#name : #GtSourceCoder,
	#superclass : #GtCoderModel,
	#instVars : [
		'sourceCode',
		'astCache',
		'completionStrategy'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'api - addons' }
GtSourceCoder >> addCopyCutPasteContextMenuAddOnsTo: coderAddOns [
	<gtCoderContextMenuAddOns: 10>
	coderAddOns
		addContextMenuItem: 'Cut' action: [ :anEditorElement | anEditorElement editor cutSelected ];
		addContextMenuItem: 'Copy'
			action: [ :anEditorElement | anEditorElement editor copySelected ];
		addContextMenuItem: 'Paste' action: [ :anEditorElement | anEditorElement editor paste ]
]

{ #category : #updating }
GtSourceCoder >> addOnChanged: aSymbol [
	aSymbol = #stylers
		ifTrue: [ self notifyStylersUpdated ].
	super addOnChanged: aSymbol
]

{ #category : #'initialize-release' }
GtSourceCoder >> addOnsClass [
	^ GtSourceCoderAddOns
]

{ #category : #'api - performing actions' }
GtSourceCoder >> browseClassFrom: anEditorElement [
	self
		pharoBehaviorInSelectionOrAtCursorInEditor: anEditorElement editor
		ifFound: [ :aBehavior | anEditorElement phlow spawnTool: (GtClassCoderTool observedClass: aBehavior) ]
		ifNone: [  ]
]

{ #category : #'api - performing actions' }
GtSourceCoder >> browseImplementorsFrom: anEditorElement [
	| symbol |

	symbol := (self selectedSourceInEditor: anEditorElement editor)
		ifEmpty: [ self selectorAtCursorInEditor: anEditorElement editor ]
		ifNotEmpty: [ :currentSelection | self extractSelectorFromString: currentSelection ].

	symbol isNil
		ifTrue: [ ^ self ].

	anEditorElement phlow spawnObject: (GtSearchImplementorsFilter selector: symbol)
]

{ #category : #'api - performing actions' }
GtSourceCoder >> browseReferencesFrom: anEditorElement [
	| filter |

	filter := (self selectedSourceInEditor: anEditorElement editor)
		ifEmpty: [
			self expanded
				ifTrue: [ self referencesFilterAtCursorIn: anEditorElement ] ]
		ifNotEmpty: [ :currentSelection | self extractReferencesFilterFromString: currentSelection ].

	filter isNil
		ifTrue: [ ^ self ].

	anEditorElement phlow spawnObject: filter
]

{ #category : #'event handling' }
GtSourceCoder >> buildCollapsedText [
	| firstLine |
	
	self halt.
	
	firstLine := (self sourceText asString lines
		detect: [ :each | each notEmpty ]
		ifNone: [ '' ]) asRopedText.
	firstLine
		attributes: self defaultTextAttributes , self disabledTextAttributes.
	^ firstLine
]

{ #category : #private }
GtSourceCoder >> classOrMetaClass [
	^ self object class
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

{ #category : #'api - accessing' }
GtSourceCoder >> collapsedText [
	^ sourceCode collapsedText
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

{ #category : #accessing }
GtSourceCoder >> currentSourceString [
	"Return a String representation of the current source text"
	<return: #String>

	^ sourceCode sourceString
]

{ #category : #private }
GtSourceCoder >> cursorPositionDo: aBlock [
	self halt.
	self sourceEditor cursor do: [ :each | ^ aBlock value: each position ]
]

{ #category : #private }
GtSourceCoder >> cursorPositionIn: aBrTextEditor do: aBlock [
	aBrTextEditor cursor do: [ :each | ^ aBlock value: each position ]
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

{ #category : #'api - performing actions' }
GtSourceCoder >> debugSelectionFrom: anEditorElement [
	^ anEditorElement editor hasSelection
		ifTrue: [ self
			debugSource: (self selectedSourceInEditor: anEditorElement editor)
			from: anEditorElement ]
		ifFalse: [ self debugSource: self source from: anEditorElement ]
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

{ #category : #'api - performing actions' }
GtSourceCoder >> discardChanges [
	"Discard not-accepted changes."
]

{ #category : #'api - performing actions' }
GtSourceCoder >> doItAll: anEditorElement [
	^ self
		evaluateSource: self source
		in: anEditorElement
]

{ #category : #'api - performing actions' }
GtSourceCoder >> doItAndGoAll: anEditorElement [
	| aSource aValue |

	aSource := self source.
	aValue := self evaluateSource: aSource in: anEditorElement.
	aValue == self
		ifTrue: [ ^ self ].
	
	anEditorElement phlow spawnObject: aValue
]

{ #category : #'api - performing actions' }
GtSourceCoder >> doItAndGoSelectionFrom: anEditorElement [
	| source value |
	source := self selectedSourceInEditor: anEditorElement editor.
	source isEmpty
		ifTrue: [ ^ self ].
	value := self evaluateSource: source in: anEditorElement.
	value == self
		ifTrue: [ ^ self ].
	anEditorElement phlow spawnObject: value
]

{ #category : #'api - performing actions' }
GtSourceCoder >> doItAndGoSelectionOrAll: anEditorElement [
	anEditorElement editor hasSelection
		ifTrue: [ self doItAndGoSelectionFrom: anEditorElement ] 
		ifFalse: [ self doItAndGoAll: anEditorElement ]
]

{ #category : #'api - performing actions' }
GtSourceCoder >> doItSelectionFrom: anEditorElement [
	"Evaluate a selected piece of source code and return a result.
	I am also able to evaluate an empty or only consisting of whitespace
	source code in which case the result is nil"
	<return: #Object>

	^ self
		evaluateSource: (self selectedSourceInEditor: anEditorElement editor)
		in: anEditorElement
]

{ #category : #'api - performing actions' }
GtSourceCoder >> doItSelectionOrAll: anEditorElement [
	^ anEditorElement editor hasSelection 
		ifTrue: [ self doItSelectionFrom: anEditorElement ] 
		ifFalse: [ self doItAll: anEditorElement ]
]

{ #category : #'private - actions' }
GtSourceCoder >> evaluateBlock: aBlock showPrintString: aBoolean in: anEditorElement [
	| aResult wasErrorAlreadySignaled |
	
	self clearPreviousEvaluationsInText: anEditorElement editor text.

	wasErrorAlreadySignaled := true. "Follow the normal way of opening the debugger for now."
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
						sourceCoder: self) ].
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
		evaluateBlock: [ 
			self classOrMetaClass compiler
				source: aString;
				receiver: self object;
				context: self context;
				requestor: ((self evaluationRequesterForEditor: anEditorElement editor) source: aString);
				failBlock: [ ^ self flag: 'insert error adornment' ];
				evaluate ] 
		showPrintString: aBoolean
		in: anEditorElement
]

{ #category : #'api - performing actions' }
GtSourceCoder >> evaluationRequesterForEditor: anEditorElement [
	^ GtSourceCoderEvaluationRequester on: self editor: anEditorElement
]

{ #category : #private }
GtSourceCoder >> expandedUpdated [
	super expandedUpdated.
	self requestStyleSourceText.
	self expanded
		ifFalse: [ self requestUpdateCollapsedText ]
]

{ #category : #private }
GtSourceCoder >> extractReferencesFilterFromString: selectedString [
	| node |
	node := GtPharoParser 
		parseWithErrors: selectedString
		startingAt: GtPharoParser startingStateForStatement.
	[ node isNil ]
		whileFalse: [ 
			(node isKindOf: GtPharoVariableNode)
				ifTrue: [ 
					| binding |
					binding := self classOrMetaClass bindingOf: node name source.
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

{ #category : #ui }
GtSourceCoder >> gtViewStylersFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewStylersFor: aView ]
]

{ #category : #'initialize-release' }
GtSourceCoder >> initialize [
	super initialize.
	self resetASTCache
]

{ #category : #'initialize-release' }
GtSourceCoder >> initializeAddOns [
	super initializeAddOns.
	addOns addStyler: BrRBTextStyler new.
	addOns clearChanges
]

{ #category : #'initialize-release' }
GtSourceCoder >> initializeShortcuts [

	addOns
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryM;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aSourceCoder |
				aSourceCoder browseImplementorsFrom: aShortcutEvent currentTarget ];
			options: self);
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryN;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aSourceCoder |
				aSourceCoder browseReferencesFrom: aShortcutEvent currentTarget ];
			options: self);
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryB;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aSourceCoder |
				aSourceCoder browseClassFrom: aShortcutEvent currentTarget ];
			options: self);
		addShortcut: (BrTextEditorShortcut new
			combination: (BlKeyCombination primaryL);
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aSourceCoder |
				aSourceCoder discardChanges ];
			options: self)
]

{ #category : #private }
GtSourceCoder >> newCompletionStrategy [
	^ GtPharoCompletionStrategy new
		classOrMetaClass: self classOrMetaClass;
		yourself
]

{ #category : #updating }
GtSourceCoder >> newRbAST: aString [
	| ast |
	ast := self parseExpression: aString requestor: nil.
	ast doSemanticAnalysis.
	^ ast
]

{ #category : #private }
GtSourceCoder >> newSourceStylerFrom: anEditorElement [
	| anAddOnsCopy |
	anAddOnsCopy := addOns stylers copy.
	anAddOnsCopy do: [ :eachAddOn | 
		eachAddOn editorElement: anEditorElement ].
	^ (GtSourceCoderTextStyler forCoder: self)
		stylers: anAddOnsCopy;
		yourself
]

{ #category : #updating }
GtSourceCoder >> newSourceText [
	<retrun: #BlText>

	^ self sourceText
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
GtSourceCoder >> notifySourceChanged [
	"Notify the text editor that it should update the text (for example due to refactoring changes)"
	
	self announce: (GtCoderSourceCodeChanged new coder: self)
]

{ #category : #'private - notifying' }
GtSourceCoder >> notifyStylersUpdated [
	"Is sent when AddOn stylers changed. It also means that the text editor should restyle the text"

	self announce: (GtCoderStylerChanged new
		coder: self;
		stylers: addOns stylers copy)
]

{ #category : #accessing }
GtSourceCoder >> object [
	^ self attributeNamed: #object
]

{ #category : #accessing }
GtSourceCoder >> object: anObject [
	anObject isNil
		ifTrue: [ self removeAttributeNamed: #object ]
		ifFalse: [ self attributeNamed: #object put: anObject ]
]

{ #category : #private }
GtSourceCoder >> parse: aString asExpression: isExpression requestor: aRequestor [
	^ (self classOrMetaClass ifNil: [ UndefinedObject ]) compiler
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

{ #category : #'api - performing actions' }
GtSourceCoder >> printItAll: anEditorElement [
	^ self
		evaluateSource: self source
		showPrintString: true
		in: anEditorElement
]

{ #category : #'api - performing actions' }
GtSourceCoder >> printItSelection: anEditorElement [
	^ self
		evaluateSource: (self selectedSourceInEditor: anEditorElement editor)
		showPrintString: true
		in: anEditorElement
]

{ #category : #'api - performing actions' }
GtSourceCoder >> printItSelectionOrAll: anEditorElement [
	^ anEditorElement editor hasSelection 
		ifTrue: [ self printItSelection: anEditorElement ] 
		ifFalse: [ self printItAll: anEditorElement ]
]

{ #category : #updating }
GtSourceCoder >> rbAST [
	| source |

	"The AST should be built out of the `characters` of the source text.
	This is needed to support `crlf` and logical items
	see https://github.com/feenkcom/gtoolkit/issues/593"
	source := self newSourceText characters asString.
	astCache key = source
		ifTrue: [ ^ astCache value ].
	^ [ 
		astCache := source -> (self newRbAST: source).
		astCache value ]
	on: Error
	do: [ :ex | ex return: nil ]
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

	self announce: (GtCoderStyleTextRequest new coder: self)
]

{ #category : #'api - text' }
GtSourceCoder >> requestUpdateCollapsedText [
	"Request to update the collapsed text, for example due to changes in the current source text.
	It is not guaranteed that the collapsed text actually changes as for example in the method coder
	opened on a compiled method"

	sourceCode resetCollapsedText.
	self announce: (GtCoderCollapsedLabelChanged new coder: self)
]

{ #category : #'api - performing actions' }
GtSourceCoder >> requester [
	self halt
]

{ #category : #'api - performing actions' }
GtSourceCoder >> requesterForEditor: aTextEditor [
	^ GtSourceCoderRequester on: self editor: aTextEditor
]

{ #category : #'api - performing actions' }
GtSourceCoder >> resetASTCache [
	astCache := nil -> nil
]

{ #category : #'private - text' }
GtSourceCoder >> selectedSourceInEditor: aBrTextEditor [
	<return: #String>

	^ aBrTextEditor selectedText characters asString
]

{ #category : #private }
GtSourceCoder >> selectedSourceInterval [
	self halt
]

{ #category : #'private - text' }
GtSourceCoder >> selectedSourceIntervalInEditor: aBrTextEditor [
	<return: #Interval>

	aBrTextEditor selection
		do: [ :eachMonotoneSelection | ^ eachMonotoneSelection from + 1 to: eachMonotoneSelection to ].

	^ 0 to: 0
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

{ #category : #accessing }
GtSourceCoder >> source [
	<return: #String>

	self
		deprecated: 'Use #currentSourceString instead'
		transformWith: '`@receiver source' -> '`@receiver currentSourceString'.
]

{ #category : #accessing }
GtSourceCoder >> source: aString [
	"Change the source text of the current coder to a given string"
	| aNewSourceText |

	"self halt."

	aNewSourceText := aString asRopedText.
	aNewSourceText attributes: self defaultTextAttributes.

	self sourceChanged.
	self notifySourceChanged.
]

{ #category : #private }
GtSourceCoder >> sourceAst [
	^ GtPharoParser parseWithErrors: self source startingAt: self parserStartingState
]

{ #category : #'event handling' }
GtSourceCoder >> sourceChanged [

	self flag: #TODO. "is there a better way to clear syntax errors than remove attributes affter *every* keystroke?"
	self clearSyntaxErrors.

	self requestUpdateCollapsedText.
	self requestAddOnsUpdate
]

{ #category : #accessing }
GtSourceCoder >> sourceCode [
	<return: #GtCoderSourceCode>

	^ sourceCode
]

{ #category : #private }
GtSourceCoder >> sourceEditor [
	<return: #BrTextEditor>

	self halt.

	^ nil
]

{ #category : #private }
GtSourceCoder >> sourceInterval [
	^ 1 to: self sourceText size
]

{ #category : #'private - text' }
GtSourceCoder >> sourceIntervalInEditor: aBrTextEditor [
	"Return the interval that represents the whole source text (first character to last character)"
	<return: #Interval>

	^ 1 to: aBrTextEditor text size
]

{ #category : #'api - accessing' }
GtSourceCoder >> sourceText [
	"Return a source text for this coder. The computation of the source text may be expensive, use me with caution.
	If the operation you would like to perform on the source text is optional consider using #sourceTextDo:"
	<return: #BlText>

	^ sourceCode sourceText
]

{ #category : #'api - accessing' }
GtSourceCoder >> sourceTextDo: aBlock [
	"Evaluate a given block with my source code text if present"

	^ sourceCode sourceTextDo: aBlock
]

{ #category : #'private - actions' }
GtSourceCoder >> styleResult: value at: interval showPrintString: aBoolean inText: aBlText [
	aBlText
		attributes:
			{(GtPlaygroundEvaluatedCodeButtonAttribute new result: value)}
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

{ #category : #updating }
GtSourceCoder >> styleText [
	"Notify the text editor that it should restyle the text (for example due to environmental changes)"
	
	self
		deprecated: 'use #styleSourceText'
		transformWith: '`@receiver styleText' -> '`@receiver styleSourceText'.
]

{ #category : #elements }
GtSourceCoder >> stylerView: anElement [
	"self sourceEditor view: anElement.
	self styleText."
]

{ #category : #'api - addons' }
GtSourceCoder >> stylers [
	^ addOns stylers
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

{ #category : #'api - addons' }
GtSourceCoder >> updateAddOnsCommand [
	^ [ | updatedAddOns pragmas ast |
	ast := self rbAST.
	pragmas := self
		pragmasNamed: #gtAstCoderAddOns:
		inHierarchy: self class.
	updatedAddOns := addOns copy.
	pragmas
		reverseDo:
			[ :each | self perform: each methodSelector with: ast with: updatedAddOns ].
	addOns := updatedAddOns.
	addOns markAsUpdated.
	updatedAddOns changesDo: [ :each | self addOnChanged: each ].
	updatedAddOns clearChanges ] asBlTktTerminableCommand
]

{ #category : #'api - addons' }
GtSourceCoder >> updateAddOnsFrom: anElement [
	"Start the update of the addons in a context of a given element"

	addOnMonitor
		critical: [			 
			BlUseAsyncFeatures 
				ifEnabledDo: [ 
					self terminateAddOnsCommand.
					addOnCommand := self updateAddOnsCommand.
					addOnCommand name: 'AddOns: ' , self identityHash printString.
					BlTktWorkerProvider highUICPUBoundPool schedule: addOnCommand ]
				otherwise: [ 
					self updateAddOnsCommand execute ] ]
]

{ #category : #'api - addons' }
GtSourceCoder >> updateContextMenuAddOnsFrom: anEditorElement [
	| updatedAddOns pragmas |
	pragmas := self
		pragmasNamed: #gtCoderContextMenuAddOns:
		inHierarchy: self class.
	updatedAddOns := addOns copy.
	updatedAddOns clearContextMenu.
	pragmas
		do: [ :each | self perform: each methodSelector withEnoughArguments: { updatedAddOns. anEditorElement } ].
	addOns := updatedAddOns.
	updatedAddOns clearChanges
]

{ #category : #private }
GtSourceCoder >> validateSyntax [
	[ GtPharoParser parse: self source startingAt: self parserStartingState ]
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

	aTextEditor cursor isSingle
		ifFalse: [ ^ aNoneBlock value ].

	aTextEditor cursor do: [ :aCursor |
		^ self variableNodeAtCursorPosition: aCursor position ifFound: aFoundBlock ifNone: aNoneBlock ].
	
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
