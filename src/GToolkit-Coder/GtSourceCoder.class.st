Class {
	#name : #GtSourceCoder,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'sourceEditor',
		'expanded',
		'attributes',
		'addOns',
		'collapsedEditor',
		'astCache',
		'completionStrategy'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtSourceCoder >> addOns [
	^ addOns
]

{ #category : #elements }
GtSourceCoder >> addShortcutsTo: editorElement [
	addOns shortcuts
		do: [ :each | editorElement addShortcut: (each copy action: [ each action cull: editorElement ]) ]
]

{ #category : #updating }
GtSourceCoder >> announce: anAnnouncement [
	announcer announce: anAnnouncement
]

{ #category : #accessing }
GtSourceCoder >> announcer [
	^ announcer
]

{ #category : #elements }
GtSourceCoder >> asElement [
	| expander |
	expander := BrExpander new.
	expander
		vFitContent;
		hMatchParent.
	expanded
		ifTrue: [ expander expand ].
	expander look: GtCoderExpanderLook new.
	expander header: [ self collapsedElement ].
	expander content: [ self sourceElement ].
	expander margin: (BlInsets all: 8).
	^ expander
]

{ #category : #'accessing-attributes' }
GtSourceCoder >> attributeNamed: aSymbol [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: [  ] ]
]

{ #category : #'accessing-attributes' }
GtSourceCoder >> attributeNamed: aSymbol ifAbsent: aBlock [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: aBlock ]
		ifFalse: [ aBlock value ]
]

{ #category : #'accessing-attributes' }
GtSourceCoder >> attributeNamed: aSymbol put: anObject [
	^ self attributes at: aSymbol put: anObject
]

{ #category : #'accessing-attributes' }
GtSourceCoder >> attributes [
	^ attributes ifNil: [ attributes := IdentityDictionary new ]
]

{ #category : #actions }
GtSourceCoder >> browseClass: editorElement [
	| variable varName behavior |
	variable := self selectedSource 
		ifNil: [ self variableNodeAtCursor ]
		ifNotNil: [:currentSelection | self extractVariableNodeFromString: currentSelection ].
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
	symbol := self selectedSource 
		ifNil: [ self selectorAtCursor ] 
		ifNotNil: [ :currentSelection | self extractSelectorFromString: currentSelection ].
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
	filter := self selectedSource
		ifNil: [ self referencesFilterAtCursor ]
		ifNotNil: [ :currentSelection | self extractReferencesFilterFromString: currentSelection ].
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
			GtMethodCoderErrorAttribute} anySatisfy: [ :cls | each isKindOf: cls ] ].
	self sourceEditor
		invalidateAll;
		updateAll
]

{ #category : #private }
GtSourceCoder >> clearSyntaxErrors: textEditor [
	textEditor isNil
		ifTrue: [ ^ self ].
	textEditor text clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ]
]

{ #category : #ui }
GtSourceCoder >> collapsedEditor [
	^ collapsedEditor ifNil: [ collapsedEditor := self newCollapsedEditor ]
]

{ #category : #ui }
GtSourceCoder >> collapsedElement [
	| element |
	element := BrEditorElement new.
	element editor: self collapsedEditor.
	^ element
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
	^ nil
]

{ #category : #accessing }
GtSourceCoder >> collapsedText [
	^ self collapsedEditor text
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
GtSourceCoder >> context [
	^ nil
]

{ #category : #'actions - toolbar' }
GtSourceCoder >> contextActions [
	"Return a collection of contextual actions in the method coder. They are renderred separately from mainActions"

	<return: #Collection of: #GtCoderAction>
	^ addOns contextActions
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
	
	self flag: 'Use the registered debugger later on'.
	GtExpandableDebuggerElement openInspectorOn: debugSession.
	"Smalltalk tools debugger openOn: debugSession withFullView: true."
]

{ #category : #actions }
GtSourceCoder >> debugSelection [
	| source |
	source := self selectedSource.
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
	(BlFontSizeAttribute size: 12) beNotOverwritableByStyler}
]

{ #category : #private }
GtSourceCoder >> disabledTextAttributes [
	^ {(BlTextForegroundAttribute paint: BrGlamorousColors disabledButtonTextColor)}
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
GtSourceCoder >> doItSelection [
	| source |
	source := self selectedSource.
	source isNil
		ifTrue: [ ^ self ].
	^ self evaluateSource: source
]

{ #category : #private }
GtSourceCoder >> evaluateSource: aString [
	^ self evaluateSource: aString showPrintString: false
]

{ #category : #private }
GtSourceCoder >> evaluateSource: aString showPrintString: aBoolean [
	| value errorAlreadySignaled |
	
	self clearPreviousEvaluations.
	[ 
		errorAlreadySignaled := false.
		value := self classOrMetaClass compiler
			source: aString;
			receiver: self object;
			context: self context;
			requestor: (self evaluationRequester source: aString);
			failBlock: [ ^ self flag: 'insert error adornment' ];
			evaluate
	] on: Error do: [ :anError |
		self resetASTCache.
		errorAlreadySignaled 
			ifTrue: [ 
				"Continue the handling of this exception. This will open a debugger 
				if the error is not caught elsewhere."
				anError pass ]
			ifFalse: [
				errorAlreadySignaled := true.
				anError resignalAs:
					(GtCoderEvaluationUnhandledError new
						exception: anError;
						sourceCoder: self) ].
		"The process will be terminated. Return nil in case there is some error whil opening the debugger
		that prevents the debugger from opening and does not kill the process."
		^ nil ].
		
	self resetASTCache.
	self announce: (GtCoderEvaluationAnnouncement forCoder: self value: value isException: false).
	self sourceEditor styleTextAndAfterDo: [
		self styleResult: value showPrintString: aBoolean ].
	^ value
]

{ #category : #actions }
GtSourceCoder >> evaluationRequester [
	^ GtMethodCoderEvaluationRequester on: self
]

{ #category : #accessing }
GtSourceCoder >> expanded [
	^ expanded
]

{ #category : #accessing }
GtSourceCoder >> expanded: aBoolean [
	expanded := aBoolean
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
GtSourceCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 10;
		stencil: [ self ]
]

{ #category : #ui }
GtSourceCoder >> gtViewContextActionsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewContextActionsFor: aView ]
]

{ #category : #ui }
GtSourceCoder >> gtViewKeybindingsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewKeybindingsFor: aView ]
]

{ #category : #ui }
GtSourceCoder >> gtViewMainActionsFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewMainActionsFor: aView ]
]

{ #category : #ui }
GtSourceCoder >> gtViewStylersFor: aView [
	<gtView>
	^ self addOns 
		ifNil: [ aView ]
		ifNotNil: [ :currentAddOns | currentAddOns gtViewStylersFor: aView ]
]

{ #category : #testing }
GtSourceCoder >> hasObjectAttribute [
	self 
		attributeNamed: #object 
		ifAbsent: [ ^ false ].
	^ true
]

{ #category : #'initialize-release' }
GtSourceCoder >> initialize [
	super initialize.
	announcer := Announcer new.
	expanded := false.
	self resetASTCache.
	self initializeAddOns
]

{ #category : #'initialize-release' }
GtSourceCoder >> initializeAddOns [
	addOns := GtMethodCoderAddOns new.
	self initializeShortcuts
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
			action: [ :editorElement | self browseClass: editorElement ])
]

{ #category : #testing }
GtSourceCoder >> isBuilt [
	^ true
]

{ #category : #'actions - toolbar' }
GtSourceCoder >> mainActions [
	"Return a collection of main actions in the method coder, for example save"

	<return: #Collection of: #GtCoderAction>
	^ addOns mainActions
]

{ #category : #accessing }
GtSourceCoder >> methodsCoder [
	^ self attributeNamed: #methodsCoder
]

{ #category : #accessing }
GtSourceCoder >> methodsCoder: aCoder [
	^ self attributeNamed: #methodsCoder put: aCoder
]

{ #category : #private }
GtSourceCoder >> newCollapsedEditor [
	^ BrTextEditor new
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
	^ self source
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
	^ GtCoderTextStyler forCoder: self
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
	| source |
	source := self selectedSource.
	source isNil
		ifTrue: [ ^ self ].
	^ self evaluateSource: source showPrintString: true
]

{ #category : #updating }
GtSourceCoder >> rbAST [
	| source |
	source := self newSource.
	astCache key = source
		ifTrue: [ ^ astCache value ].
	^ [ astCache := source -> (self newRbAST: source).
	astCache value ]
		on: Error
		do: [ :ex | ex return: nil ]
]

{ #category : #private }
GtSourceCoder >> referencesFilterAtCursor [
	| node |
	node := self nodeAtCursor.
	[ node isNil ]
		whileFalse: [ 
			(node isKindOf: GtPharoVariableNode)
				ifTrue: [ ^ self referencesFilterForVariable: node name source ].
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

{ #category : #updating }
GtSourceCoder >> refreshForChanges [
	addOns
		changesDo: [ :each | 
			each = #stylers
				ifTrue: [ self styleText ].
			each = #mainActions
				ifTrue: [ self announce: (GtCoderMethodMainActionsChanged new coder: self) ].
			each = #contextActions
				ifTrue: [ self announce: (GtCoderMethodContextActionsChanged new coder: self) ] ].
	addOns clearChanges
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
	(text from: position to: position) attributes: {(GtMethodCoderErrorAttribute for: aString , ' ->')}.
	textEditor
		invalidate: position to: position;
		update: position to: position.
	textEditor moveCursorTo: position
]

{ #category : #actions }
GtSourceCoder >> requester [
	^ GtMethodCoderRequester on: self
]

{ #category : #actions }
GtSourceCoder >> resetASTCache [
	astCache := nil -> nil
]

{ #category : #private }
GtSourceCoder >> selectedSource [
	self selectedSourceInterval ifNotNil: [ :interval | 
		^ (self sourceEditor text 
				from: interval first 
				to: interval last) asString ].
	^ nil
]

{ #category : #private }
GtSourceCoder >> selectedSourceInterval [
	self sourceEditor selection do: [ :each | ^ each from + 1 to: each to ].
	^ nil
]

{ #category : #private }
GtSourceCoder >> selectorAtCursor [
	^ self symbolFor: self nodeAtCursor
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

{ #category : #ui }
GtSourceCoder >> sourceElement [
	| container element toolbar |
	container := BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ].
	element := BrEditorElement new.
	addOns shortcuts do: [ :each | element addShortcut: (each copy action: [ each action cull: element ]) ].
	element
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ].
	element editor: self sourceEditor.
	(GtCompletionController on: element strategy: self completionStrategy) install.
	toolbar := GtCoderMethodActionsElement new
		methodCoder: self;
		padding:
			(BlInsets
				top: 0
				left: -3
				bottom: -3
				right: 0);
		margin: (BlInsets top: 5).
	container addChild: element.
	container addChild: toolbar.
	^ container
]

{ #category : #accessing }
GtSourceCoder >> sourceText [
	^ self sourceEditor text
]

{ #category : #private }
GtSourceCoder >> styleCollapsedText [
	| text |
	text := self collapsedEditor text text.
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
	| interval |
	interval := self selectedSourceInterval.
	self styleResult: value at: interval showPrintString: aBoolean.
	self sourceEditor
		invalidateAll;
		updateAll
]

{ #category : #private }
GtSourceCoder >> styleSourceText [
	self sourceEditor styleText
]

{ #category : #updating }
GtSourceCoder >> styleText [
	self isBuilt
		ifFalse: [ ^ self ].
	self styleSourceText.
	self styleCollapsedText
]

{ #category : #accessing }
GtSourceCoder >> stylers [
	^ addOns stylers
]

{ #category : #subscriptions }
GtSourceCoder >> subscribeToSystem [
	"do nothing"
]

{ #category : #private }
GtSourceCoder >> symbolFor: aNode [
	| current |
	current := aNode.
	[ current notNil ]
		whileTrue: [ 
			(current isKindOf: GtPharoSymbolLiteralNode)
				ifTrue: [ ^ aNode asSymbol ].
			(current isKindOf: GtPharoMessageSendNode)
				ifTrue: [ current := current message ].
			(current isKindOf: GtPharoMessageNode)
				ifTrue: [ ^ current selector ].
			current := current parent ].
	^ nil
]

{ #category : #subscriptions }
GtSourceCoder >> unsubscribeFromSystem [
	SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : #updating }
GtSourceCoder >> updateAddOns [
	| pragmas ast |
	ast := self rbAST.
	pragmas := self pragmasNamed: #gtAstCoderAddOns: inHierarchy: self class.
	pragmas reverseDo: [ :each | self perform: each methodSelector with: ast ].
	self refreshForChanges
]

{ #category : #'event handling' }
GtSourceCoder >> updateCollapsedSource [
	| firstLine |
	firstLine := (self sourceEditor text asString lines detect: [ :each | each notEmpty ] ifNone: [ '' ]) asRopedText.
	firstLine attributes: self disabledTextAttributes , self defaultTextAttributes.
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
