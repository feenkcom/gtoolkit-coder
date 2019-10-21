Class {
	#name : #GtSourceCoder,
	#superclass : #GtCoder,
	#instVars : [
		'sourceEditor',
		'collapsedEditor',
		'astCache',
		'completionStrategy'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #private }
GtSourceCoder >> activeSelectedSource [
	self activeSelectedSourceInterval
		ifNotNil: [ :interval | 
			^ (self activeSourceEditor text from: interval first to: interval last)
				asString ].
	^ nil
]

{ #category : #private }
GtSourceCoder >> activeSelectedSourceInterval [
	self activeSourceEditor selection
		do: [ :each | ^ each from + 1 to: each to ].
	^ nil
]

{ #category : #private }
GtSourceCoder >> activeSourceEditor [
	^ self expanded
		ifTrue: [ self sourceEditor ]
		ifFalse: [ self collapsedEditor ]
]

{ #category : #updating }
GtSourceCoder >> addOnChanged: aSymbol [
	aSymbol = #stylers
		ifTrue: [ self styleText ].
	super addOnChanged: aSymbol
]

{ #category : #'initialize-release' }
GtSourceCoder >> addOnsClass [
	^ GtSourceCoderAddOns
]

{ #category : #actions }
GtSourceCoder >> browseClass: editorElement [
	| variable varName behavior |
	variable := self activeSelectedSource
		ifNil: [ self expanded
				ifTrue: [ self variableNodeAtCursor ]
				ifFalse: [ self collapsedVariableNode ] ]
		ifNotNil:
			[ :currentSelection | self extractVariableNodeFromString: currentSelection ].
	variable isNil
		ifTrue: [ ^ self ].
	varName := variable name value asSymbol.
	behavior := Smalltalk globals at: varName ifAbsent: [ ^ self ].
	behavior isBehavior
		ifFalse: [ ^ self ].
	editorElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: (GtClassCoder forClass: behavior);
				sourceElement: editorElement)
]

{ #category : #actions }
GtSourceCoder >> browseImplementors: editorElement [
	| symbol |
	symbol := self activeSelectedSource
		ifNil: [ self expanded
				ifTrue: [ self selectorAtCursor ]
				ifFalse: [ self selectorForCollapsed ] ]
		ifNotNil:
			[ :currentSelection | self extractSelectorFromString: currentSelection ].
	symbol isNil
		ifTrue: [ ^ self ].
	editorElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: (GtSearchImplementorsFilter selector: symbol);
				sourceElement: editorElement)
]

{ #category : #actions }
GtSourceCoder >> browseReferences: editorElement [
	| filter |
	filter := self activeSelectedSource
		ifNil: [ self expanded
				ifTrue: [ self referencesFilterAtCursor ]
				ifFalse: [ self referencesFilterForCollapsed ] ]
		ifNotNil:
			[ :currentSelection | self extractReferencesFilterFromString: currentSelection ].
	filter isNil
		ifTrue: [ ^ self ].
	editorElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: filter;
				sourceElement: editorElement)
]

{ #category : #private }
GtSourceCoder >> classOrMetaClass [
	^ self object class
]

{ #category : #private }
GtSourceCoder >> clearPreviousEvaluations [
	self sourceText
		clearAttributes: [ :each | 
			{GtPlaygroundEvaluatedCodeHighlightedAttribute.
			GtPlaygroundEvaluatedCodeButtonAttribute.
			GtCoderPrintStringAttribute.
			GtPlaygroundDebugExceptionButtonAttribute.
			GtSourceCoderErrorAttribute} anySatisfy: [ :cls | each isKindOf: cls ] ].
	self sourceEditor
		invalidateAll;
		updateAll
]

{ #category : #private }
GtSourceCoder >> clearSyntaxErrors: textEditor [
	textEditor isNil
		ifTrue: [ ^ self ].
	textEditor text clearAttributes: [ :each | each isKindOf: GtSourceCoderErrorAttribute ]
]

{ #category : #ui }
GtSourceCoder >> collapsedEditor [
	^ collapsedEditor ifNil: [ collapsedEditor := self newCollapsedEditor ]
]

{ #category : #ui }
GtSourceCoder >> collapsedEditorElement [
	^ BrEditorElement new
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		editor: self collapsedEditor;
		in: [ :e | self addShortcutsTo: e ];
		yourself
]

{ #category : #accessing }
GtSourceCoder >> collapsedSource [
	^ self collapsedText asString
]

{ #category : #accessing }
GtSourceCoder >> collapsedSource: aString [
	| text |
	text := aString asRopedText.
	self collapsedEditor text: text readonly.
	self styleCollapsedText.
]

{ #category : #ui }
GtSourceCoder >> collapsedStyler [
	^ self newSourceStyler
]

{ #category : #accessing }
GtSourceCoder >> collapsedText [
	^ self collapsedEditor text
]

{ #category : #private }
GtSourceCoder >> collapsedVariableNode [
	^ nil
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

{ #category : #private }
GtSourceCoder >> completionStrategy [
	^ completionStrategy
		ifNil: [ completionStrategy := self newCompletionStrategy ]
]

{ #category : #private }
GtSourceCoder >> completionStrategy: aCompletionStrategy [
	completionStrategy := aCompletionStrategy
]

{ #category : #private }
GtSourceCoder >> cursorPositionDo: aBlock [
	self sourceEditor cursor do: [ :each | ^ aBlock value: each position ]
]

{ #category : #private }
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

{ #category : #actions }
GtSourceCoder >> debugSelection [
	| source |
	source :=  self hasSelection
		ifTrue: [ self selectedSource ]
		ifFalse: [ self source ].
	source isNil
		ifTrue: [ ^ self ].
	^ self debugSource: source
]

{ #category : #private }
GtSourceCoder >> debugSource: aString [ 
	| currentReceiver currentContext method |
	self clearPreviousEvaluations.
	currentReceiver := self object.
	currentContext := self context.
	method := self 
		compile: aString 
		for: currentReceiver 
		in: currentContext
		withRequestor: self requester.
	method notNil ifTrue:
		[ self debug: method receiver: currentReceiver in: currentContext ].
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

{ #category : #actions }
GtSourceCoder >> discardChanges [
	"Discard not-accepted changes."
]

{ #category : #actions }
GtSourceCoder >> doItAll [
	| source |
	source := self source.
	source isNil
		ifTrue: [ ^ self ].
	^ self evaluateSource: source
]

{ #category : #actions }
GtSourceCoder >> doItAndGoAll: anElement [
	| aSource aValue |
	aSource := self source.
	aSource isNil ifTrue: [ ^ self ].
	aValue := self evaluateSource: aSource.
	aValue == self ifTrue: [ ^ self ].
	anElement phlow spawnObject: aValue
]

{ #category : #actions }
GtSourceCoder >> doItAndGoSelection: anElement [
	| source value |
	source := self selectedSource.
	source isNil
		ifTrue: [ ^ self ].
	value := self evaluateSource: source.
	value == self
		ifTrue: [ ^ self ].
	anElement phlow spawnObject: value
]

{ #category : #actions }
GtSourceCoder >> doItAndGoSelectionOrAll: anElement [
	self hasSelection
		ifTrue: [ self doItAndGoSelection: anElement ] 
		ifFalse: [ self doItAndGoAll: anElement ]
]

{ #category : #actions }
GtSourceCoder >> doItSelection [
	"Evaluate a selected piece of source code and return a result.
	I am also able to evaluate an empty or only consisting of whitespace
	source code in which case the result is nil"
	<return: #Object>

	^ self evaluateSource: self selectedSource
]

{ #category : #actions }
GtSourceCoder >> doItSelectionOrAll [
	^ self hasSelection 
		ifTrue: [ self doItSelection ] 
		ifFalse: [ self doItAll ]
]

{ #category : #private }
GtSourceCoder >> evaluateBlock: aBlock showPrintString: aBoolean [
	| aResult wasErrorAlreadySignaled |
	
	self clearPreviousEvaluations.
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
	self sourceEditor styleTextAndAfterDo: [
		self styleResult: aResult showPrintString: aBoolean ].
	^ aResult
]

{ #category : #private }
GtSourceCoder >> evaluateSource: aString [
	^ self evaluateSource: aString showPrintString: false
]

{ #category : #private }
GtSourceCoder >> evaluateSource: aString showPrintString: aBoolean [
	^ self 
		evaluateBlock: [ 
			self classOrMetaClass compiler
				source: aString;
				receiver: self object;
				context: self context;
				requestor: (self evaluationRequester source: aString);
				failBlock: [ ^ self flag: 'insert error adornment' ];
				evaluate ] 
		showPrintString: aBoolean
]

{ #category : #actions }
GtSourceCoder >> evaluationRequester [
	^ GtSourceCoderEvaluationRequester on: self
]

{ #category : #ui }
GtSourceCoder >> expandedEditorElement [
	self
		flag:
			'TODO make coder actions aware of potential use in context menu, i.e. the actions actually expect the button of the action, but in the context menu they get the editor element as an argument. this only works as long they only do phlow stuff. also, actions should have preconditions, e.g. cut and copy without selection do not make sense'.
	^ BrEditorElement new
		look:
			(BrGlamorousWithContextMenuLook
				content: [ BrGlamorousSimpleContextMenuContent new
						display:
							{('Cut' -> [ self sourceEditor cutSelected ]).
							('Copy' -> [ self sourceEditor copySelected ]).
							('Paste' -> [ self sourceEditor paste ])}
								,
									((self mainActions reject: [ :e | e title isNil ])
										collect: [ :e | e title -> e action ]);
						yourself ]);
		padding:
			(BlInsets
				top: 0
				left: 0
				bottom: 2
				right: 0);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		editor: self sourceEditor;
		in: [ :e | 
			(GtCompletionController on: e strategy: self completionStrategy)
				install.
			self addShortcutsTo: e ];
		yourself
]

{ #category : #private }
GtSourceCoder >> expandedUpdated [
	super expandedUpdated.
	self styleText.
	self expanded
		ifFalse: [ self updateCollapsedSource ]
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

{ #category : #private }
GtSourceCoder >> extractVariableNodeFromString: aString [
	| node |
	node := GtPharoParser 
		parseWithErrors: aString
		startingAt: GtPharoParser startingStateForStatement.
	[ node isNil ]
		whileFalse: [ 
			(node isKindOf: GtPharoVariableNode)
				ifTrue: [ ^ node ].
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

{ #category : #testing }
GtSourceCoder >> hasSelection [
	<return: #Boolean>

	^ self sourceEditor hasSelection
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
		addShortcut: (BlShortcut new
			combination: BlKeyCombination primaryM;
			action: [ :editorElement | self browseImplementors: editorElement ]);
		addShortcut: (BlShortcut new
			combination: BlKeyCombination primaryN;
			action: [ :editorElement | self browseReferences: editorElement ]);
		addShortcut: (BlShortcut new
			combination: BlKeyCombination primaryB;
			action: [ :editorElement | self browseClass: editorElement ]);
		addShortcut: (BlShortcut new
			combination: (BlKeyCombination primaryL);
			action: [ self discardChanges ])
]

{ #category : #private }
GtSourceCoder >> intervalToStyleResult [
	"Return interval that should be styled to display result."
	^ self selectedSourceIntervalOrAll
]

{ #category : #testing }
GtSourceCoder >> isBuilt [
	^ true
]

{ #category : #private }
GtSourceCoder >> newCollapsedEditor [
	| editor |
	editor := BrTextEditor new.
	^ editor
]

{ #category : #accessing }
GtSourceCoder >> newCollapsedText [
	<retrun: #BlText>

	^ self collapsedEditor textSnapshot
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
	ast := RBParser parseFaultyExpression: aString.
	ast doSemanticAnalysis.
	^ ast
]

{ #category : #updating }
GtSourceCoder >> newSource [
	<return: #String>
	self
		deprecated: 'Use `newSourceText asString` or `newSourceText characters asString` instead'
		transformWith: '`@receiver newSource' -> '`@receiver newSourceText asString'.

	^ self newSourceText asString
]

{ #category : #ui }
GtSourceCoder >> newSourceEditor [
	| editor |
	editor := BrTextEditor new.
	self newSourceStyler ifNotNil: [ :styler | editor styler: styler ].
	editor
		when: BrTextEditorInsertedEvent do: [ :event | self sourceChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self sourceChanged ].
	^ editor
]

{ #category : #private }
GtSourceCoder >> newSourceStyler [
	^ GtSourceCoderTextStyler forCoder: self
]

{ #category : #updating }
GtSourceCoder >> newSourceText [
	<retrun: #BlText>

	^ self sourceEditor textSnapshot
]

{ #category : #private }
GtSourceCoder >> nodeAtCursor [
	self
		cursorPositionDo: [ :position | 
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

{ #category : #accessing }
GtSourceCoder >> object [
	^ self attributeNamed: #object
]

{ #category : #accessing }
GtSourceCoder >> object: anObject [
	self attributeNamed: #object put: anObject
]

{ #category : #private }
GtSourceCoder >> parserStartingState [
	^ GtPharoParser startingStateForMethodSequence
]

{ #category : #private }
GtSourceCoder >> pragmasNamed: aSymbol inHierarchy: aClass [
	| actions |
	actions := OrderedCollection new.
	aClass withAllSuperclassesDo: [ :each | actions addAll: (Pragma allNamed: aSymbol in: each) ].
	actions sort: [ :a :b | a arguments first < b arguments first ].
	^ actions
]

{ #category : #actions }
GtSourceCoder >> printItSelection [
	^ self evaluateSource: self selectedSource showPrintString: true
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
GtSourceCoder >> referencesFilterAtCursor [
	| node |
	node := self nodeAtCursor.
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
GtSourceCoder >> referencesFilterForCollapsed [
	^ nil
]

{ #category : #private }
GtSourceCoder >> referencesFilterForSymbol: aSymbol [
	^ GtSearchReferencesFilter literal: aSymbol
]

{ #category : #private }
GtSourceCoder >> referencesFilterForVariable: aString [
	| index binding |
	index := self classOrMetaClass instVarIndexFor: aString.
	index > 0
		ifTrue: [ ^ GtSearchInstanceVariableReferenceFilter 
			forClass: self classOrMetaClass 
			andVariable: aString ].
	binding := self classOrMetaClass bindingOf: aString.
	binding notNil
		ifTrue: [ ^ GtSearchReferencesFilter literal: binding ].
	^ nil
]

{ #category : #private }
GtSourceCoder >> reportParseError: aString at: anInteger on: textEditor [
	| text position |
	textEditor isNil
		ifTrue: [ ^ self ].
	text := textEditor text.
	position := anInteger - 1 max: 1.
	text size < position
		ifTrue: [ ^ self ].
	(text from: position to: position) attributes: {(GtSourceCoderErrorAttribute for: aString , ' ->')}.
	textEditor
		invalidate: position to: position;
		update: position to: position.
	textEditor moveCursorTo: position
]

{ #category : #actions }
GtSourceCoder >> requester [
	^ GtSourceCoderRequester on: self
]

{ #category : #actions }
GtSourceCoder >> resetASTCache [
	astCache := nil -> nil
]

{ #category : #private }
GtSourceCoder >> selectedSource [
	<return: #BlText>

	^ self sourceEditor selectedText characters asString
]

{ #category : #private }
GtSourceCoder >> selectedSourceInterval [
	self sourceEditor selection do: [ :each | ^ each from + 1 to: each to ].
	^ nil
]

{ #category : #private }
GtSourceCoder >> selectedSourceIntervalOrAll [
	^ self selectedSourceInterval ifNil: [ self sourceInterval ]
]

{ #category : #private }
GtSourceCoder >> selectorAtCursor [
	^ self symbolFor: self nodeAtCursor
]

{ #category : #private }
GtSourceCoder >> selectorForCollapsed [
	^ nil
]

{ #category : #accessing }
GtSourceCoder >> source [
	^ self sourceText asString
]

{ #category : #accessing }
GtSourceCoder >> source: aString [
	| text |
	text := aString asRopedText.
	text attributes: self defaultTextAttributes.
	^ self sourceEditor text: text
]

{ #category : #private }
GtSourceCoder >> sourceAst [
	^ GtPharoParser parseWithErrors: self source startingAt: self parserStartingState
]

{ #category : #'event handling' }
GtSourceCoder >> sourceChanged [
	self clearSyntaxErrors: self sourceEditor.
	self clearSyntaxErrors: self collapsedEditor.
	self updateCollapsedSource.
	self updateAddOns
]

{ #category : #private }
GtSourceCoder >> sourceEditor [
	<return: #BrTextEditor>

	^ sourceEditor ifNil: [ sourceEditor := self newSourceEditor ]
]

{ #category : #private }
GtSourceCoder >> sourceInterval [
	^ 1 to: self source size
]

{ #category : #accessing }
GtSourceCoder >> sourceText [
	^ self sourceEditor text
]

{ #category : #private }
GtSourceCoder >> styleCollapsedText [
	| text |
	self expanded
		ifTrue: [ ^ self ].
	text := self collapsedEditor text.
	self collapsedStyler ifNotNil: [ :styler | styler style: text ].
	self collapsedEditor text: text readonly
]

{ #category : #private }
GtSourceCoder >> styleResult: value at: interval showPrintString: aBoolean [
	self sourceEditor text
		attributes:
			{(GtPlaygroundEvaluatedCodeButtonAttribute new
				result: value;
				paint: (Color fromHexString: #'90CAF9'))}
		from: interval last
		to: interval last.
	aBoolean
		ifTrue: [ self sourceEditor text
				attributes: {(GtCoderPrintStringAttribute forString: value printString)}
				from: interval last
				to: interval last ].
	self sourceEditor text
		attributes:
			{(GtPlaygroundEvaluatedCodeHighlightedAttribute new
				paint: (Color fromHexString: #'90CAF9'))}
		from: interval first
		to: interval last
]

{ #category : #private }
GtSourceCoder >> styleResult: value showPrintString: aBoolean [
	self selectedSourceIntervalOrAll ifNotNil: [ :interval |
		self 
			styleResult: value 
			at: interval 
			showPrintString: aBoolean ].
	self sourceEditor
		invalidateAll;
		updateAll
]

{ #category : #private }
GtSourceCoder >> styleSourceText [
	self expanded
		ifFalse: [ ^ self ].
	self sourceEditor styleText
]

{ #category : #updating }
GtSourceCoder >> styleText [
	self isBuilt
		ifFalse: [ ^ self ].
	self styleSourceText.
	self styleCollapsedText
]

{ #category : #elements }
GtSourceCoder >> stylerView: anElement [
	self sourceEditor view: anElement.
	self collapsedEditor view: anElement.
	self styleText.
]

{ #category : #accessing }
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

{ #category : #updating }
GtSourceCoder >> updateAddOns [
	addOnMonitor
		critical: [ self terminateAddOnsCommand.
			addOnCommand := self updateAddOnsCommand.
			addOnCommand name: 'AddOns: ' , self identityHash printString.
			BlTktWorkerProvider highUICPUBoundPool schedule: addOnCommand ]
]

{ #category : #updating }
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
	updatedAddOns changesDo: [ :each | self addOnChanged: each ].
	updatedAddOns clearChanges ] asBlTktTerminableCommand
]

{ #category : #'event handling' }
GtSourceCoder >> updateCollapsedSource [
	| firstLine |
	self expanded
		ifTrue: [ ^ self ].
	firstLine := (self sourceEditor text asString lines
		detect: [ :each | each notEmpty ]
		ifNone: [ '' ]) asRopedText.
	firstLine
		attributes: self defaultTextAttributes, self disabledTextAttributes.
	self collapsedSource: firstLine
]

{ #category : #private }
GtSourceCoder >> validateSyntax [
	[ GtPharoParser parse: self source startingAt: self parserStartingState ]
		on: SmaCCParserError
		do: [ :ex | 
			self reportParseError: ex messageText at: ex tag position on: self sourceEditor.
			self reportParseError: ex messageText at: ex tag position on: self collapsedEditor.
			^ false ].
	^ true
]

{ #category : #private }
GtSourceCoder >> variableNodeAtCursor [
	self
		cursorPositionDo: [ :position | 
			[ | ast |
			ast := self sourceAst.
			ast
				withAllNodesOfType: GtPharoVariableNode
				do: [ :node | 
					(position between: node startPosition and: node stopPosition)
						ifTrue: [ ^ node ] ] ]
				on: Error
				do: [ :ex | ex return ] ].
	^ nil
]
