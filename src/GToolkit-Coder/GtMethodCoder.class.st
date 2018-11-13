Class {
	#name : #GtMethodCoder,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'class',
		'selector',
		'sourceEditor',
		'patternEditor',
		'expanded',
		'methodSource',
		'attributes',
		'addOns',
		'subCoders'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtMethodCoder class >> forClass: aBehavior source: aString [
	^ self new
		forClass: aBehavior source: aString;
		yourself
]

{ #category : #'instance creation' }
GtMethodCoder class >> forExample: anExample [
	^ self new example: anExample 
]

{ #category : #'instance creation' }
GtMethodCoder class >> forMethod: aCompiledMethod [
	^ self new
		forMethod: aCompiledMethod;
		yourself
]

{ #category : #'instance creation' }
GtMethodCoder class >> forObject: anObject andSelector: aSymbol [
	^ (self forMethod: anObject class >> aSymbol)
		object: anObject;
		yourself
]

{ #category : #elements }
GtMethodCoder >> addBodyShortcutsTo: editorElement [
	editorElement
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key d;
						build);
				action: [ self doItSelection ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key g;
						build);
				action: [ self doItAndGoSelection: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key m;
						build);
				action: [ self browseImplementors: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key n;
						build);
				action: [ self browseReferences: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key b;
						build);
				action: [ self browseClass: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key r;
						build);
				action: [ self renameSourceVariable: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key e;
						build);
				action: [ self extractMethod: editorElement ])
]

{ #category : #examples }
GtMethodCoder >> addExampleStatus [
	self patternEditor text clearAttributes: [ :each | each isKindOf: GtExampleStatusAttribute ].
	(self patternEditor text from: self patternSource size to: self patternSource size)
		attributes: {(GtExampleStatusAttribute forResult: self exampleResult) beNotOverwritableByStyler}.
	self patternEditor
		invalidateAll;
		updateAll
]

{ #category : #elements }
GtMethodCoder >> addPatternShortcutsTo: editorElement [
	editorElement
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key r;
						build);
				action: [ self renamePatternVariable: editorElement ])
]

{ #category : #accessing }
GtMethodCoder >> addSubCoder: aMethodCoder [
	self subCoders addFirst: aMethodCoder
]

{ #category : #updating }
GtMethodCoder >> announce: anAnnouncement [
	announcer announce: anAnnouncement
]

{ #category : #accessing }
GtMethodCoder >> announcer [
	^ announcer
]

{ #category : #elements }
GtMethodCoder >> asElement [

	(methodSource notEmpty and: [ self patternSource isEmpty ])
		ifTrue: [ self buildSource ].

	^ GtCoderMethodElement new
		margin: (BlInsets all: 10);
		methodCoder: self;
		yourself
]

{ #category : #'accessing-attributes' }
GtMethodCoder >> attributeNamed: aSymbol [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: [  ] ]
]

{ #category : #'accessing-attributes' }
GtMethodCoder >> attributeNamed: aSymbol ifAbsent: aBlock [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: aBlock ]
		ifFalse: [ aBlock value ]
]

{ #category : #'accessing-attributes' }
GtMethodCoder >> attributeNamed: aSymbol put: anObject [
	^ self attributes at: aSymbol put: anObject
]

{ #category : #'accessing-attributes' }
GtMethodCoder >> attributes [
	^ attributes ifNil: [ attributes := IdentityDictionary new ]
]

{ #category : #'event handling' }
GtMethodCoder >> bodyChanged [
	self clearSyntaxErrors: self sourceEditor.
	self updateAddOns
]

{ #category : #accessing }
GtMethodCoder >> bodySource [
	^ self sourceEditor text asString
]

{ #category : #styling }
GtMethodCoder >> bodyStylerForClass: stylerClass [
	| aStyler |
	aStyler := stylerClass new.
	aStyler classOrMetaClass: self classOrMetaClass.
	aStyler methodPatternSource: self patternSource.
	aStyler highlighter: self highlighter.
	^ aStyler
]

{ #category : #accessing }
GtMethodCoder >> bodyStylers [
	^ addOns bodyStylers
]

{ #category : #actions }
GtMethodCoder >> browseClass: editorElement [
	| variable varName behavior |
	variable := self variableAtCursor.
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
GtMethodCoder >> browseImplementors: editorElement [
	| symbol |
	symbol := self selectorAtCursor.
	symbol isNil
		ifTrue: [ ^ self ].
	editorElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: (GtCoderMethodsCollection forImplementors: symbol) asCoder;
				sourceElement: editorElement)
]

{ #category : #actions }
GtMethodCoder >> browseReferences: editorElement [
	| coder |
	coder := self referencesCoderAtCursor.
	coder isNil
		ifTrue: [ ^ self ].
	editorElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: coder;
				sourceElement: editorElement)
]

{ #category : #private }
GtMethodCoder >> buildSource [
	| patternSource ast originalBodySource index text |
	ast := GtPharoParser parse: methodSource.
	index := self findSeparatorBetweenPatternAndBodyIn: ast.
	patternSource := methodSource copyFrom: 1 to: index - 1.
	self patternSource: (self styledPatternTextFor: patternSource).
	index := self skipBlankLinesIn: methodSource at: index.
	originalBodySource := methodSource allButFirst: index - 1.
	text := originalBodySource asRopedText.
	text attributes: self defaultTextAttributes.
	self sourceEditor text: text
]

{ #category : #accessing }
GtMethodCoder >> category [
	^ (self attributeNamed: #category)
		ifNil: [ (self classOrMetaClass notNil and: [ self selector notNil ])
				ifTrue: [ self classOrMetaClass whichCategoryIncludesSelector: self selector ] ]
]

{ #category : #accessing }
GtMethodCoder >> category: aSymbol [
	^ self attributeNamed: #category put: aSymbol
]

{ #category : #actions }
GtMethodCoder >> changeManager [
	^ RBRefactoryChangeManager instance
]

{ #category : #accessing }
GtMethodCoder >> classOrMetaClass [
	^ class
]

{ #category : #accessing }
GtMethodCoder >> classOrMetaClass: aBehavior [
	class := aBehavior
]

{ #category : #private }
GtMethodCoder >> clearPatternSyntaxErrors [
	self patternEditor text clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ]
]

{ #category : #private }
GtMethodCoder >> clearPreviousEvaluations [
	self sourceEditor text clearAttributes: [ :each | each isKindOf: GtPlaygroundEvaluatedCodeButtonAttribute ].
	self sourceEditor
		invalidateAll;
		updateAll
]

{ #category : #private }
GtMethodCoder >> clearSyntaxErrors: textEditor [
	textEditor text clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ]
]

{ #category : #private }
GtMethodCoder >> compile [
	| change |
	subCoders notNil
		ifTrue: [ subCoders
				do: [ :each | 
					each compile
						ifFalse: [ ^ false ] ] ].
	change := self category
		ifNil: [ RBAddMethodChange compile: self newMethodSource in: self classOrMetaClass for: self requester ]
		ifNotNil: [ :category | 
			RBAddMethodChange
				compile: self newMethodSource
				in: self classOrMetaClass
				classified: category
				for: self requester ].
	self changeManager performChange: change.
	change definedSelector
		ifNotNil: [ :sel | 
			self selector: sel.
			self compiledMethod
				ifNotNil: [ :method | 
					methodSource := method sourceCode.
					^ true ] ].
	^ false
]

{ #category : #accessing }
GtMethodCoder >> compiledMethod [
	^ self classOrMetaClass
		ifNotNil: [ :cls | 
			self selector
				ifNotNil: [ :sel | 
					(cls canUnderstand: sel)
						ifTrue: [ cls >> sel ] ] ]
]

{ #category : #private }
GtMethodCoder >> context [
	^ nil
]

{ #category : #'actions - toolbar' }
GtMethodCoder >> contextActions [
	"Return a collection of contextual actions in the method coder. They are renderred separately from mainActions"

	<return: #Collection of: #GtCoderAction>
	^ addOns contextActions
]

{ #category : #private }
GtMethodCoder >> cursorPositionDo: aBlock [
	self sourceEditor cursor do: [ :each | ^ aBlock value: each position ]
]

{ #category : #private }
GtMethodCoder >> defaultTextAttributes [
	^ {BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
	(BlFontSizeAttribute size: 14) beNotOverwritableByStyler}
]

{ #category : #actions }
GtMethodCoder >> doItAndGoSelection: editorElement [
	| source value |
	source := self selectedSource.
	source isNil
		ifTrue: [ ^ self ].
	value := self evaluateSource: source.
	value == self
		ifTrue: [ ^ self ].
	editorElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: value;
				sourceElement: editorElement)
]

{ #category : #actions }
GtMethodCoder >> doItSelection [
	| source |
	source := self selectedSource.
	source isNil
		ifTrue: [ ^ self ].
	self evaluateSource: source
]

{ #category : #private }
GtMethodCoder >> evaluateSource: aString [
	| value interval |
	self clearPreviousEvaluations.
	value := self classOrMetaClass compiler
		requestor: self evaluationRequester;
		source: aString;
		receiver: self object;
		context: self context;
		failBlock: [ ^ self ];
		evaluate.
	interval := self selectedSourceInterval.
	self sourceEditor text
		attributes:
			{(GtPlaygroundEvaluatedCodeButtonAttribute new
				beNotOverwritableByStyler;
				result: value;
				paint: (Color fromHexString: #'90CAF9'))}
		from: interval last
		to: interval last.
	self sourceEditor
		invalidateAll;
		updateAll.
	^ value
]

{ #category : #actions }
GtMethodCoder >> evaluationRequester [
	^ GtMethodCoderEvaluationRequester on: self
]

{ #category : #examples }
GtMethodCoder >> example [
	^ (self attributeNamed: #example)
		ifNil: [ self compiledMethod ifNotNil: [ :method | method methodClass gtExamplesFactory createExample: method ] ]
]

{ #category : #examples }
GtMethodCoder >> example: anExample [
	self attributeNamed: #example put: anExample.
	self forMethod: anExample method
]

{ #category : #'add ons' }
GtMethodCoder >> exampleAstFor: anAST [
	<gtAstCoderAddOns: 5>
	(anAST notNil
		and: [ anAST methodNode ifNotNil: [ :node | node pragmas anySatisfy: [ :each | each selector = #gtExample ] ] ifNil: [ false ] ])
		ifFalse: [ addOns removeBodyStylerOfType: GtCoderExpandableExampleStyler.
			addOns removePatternStylerOfType: GtCoderExampleStatusStyler.
			addOns removeContextAction: 'Run' translated.
			^ self ].
	addOns addBodyStyler: GtCoderExpandableExampleStyler new.
	addOns
		addPatternStyler:
			(GtCoderExampleStatusStyler new
				coder: self;
				classOrMetaClass: self classOrMetaClass).
	addOns addContextAction: 'Run' translated icon: BrGlamorousIcons play action: [ :button | self runFrom: button ]
]

{ #category : #examples }
GtMethodCoder >> exampleResult [
	^ self attributeNamed: #exampleResult
]

{ #category : #examples }
GtMethodCoder >> exampleResult: anExampleResult [
	self attributeNamed: #exampleResult put: anExampleResult
]

{ #category : #accessing }
GtMethodCoder >> expanded [
	^ expanded
]

{ #category : #accessing }
GtMethodCoder >> expanded: aBoolean [
	expanded := aBoolean
]

{ #category : #actions }
GtMethodCoder >> extractMethod: editorElement [
	(GtExtractMethodController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #private }
GtMethodCoder >> findSeparatorBetweenPatternAndBodyIn: aMethodNode [
	| startIndex char source |
	source := aMethodNode completeSource.
	startIndex := aMethodNode pattern stopPosition + 1.
	[ startIndex <= source size and: [ (char := source at: startIndex) isSeparator and: [ char ~= Character cr ] ] ]
		whileTrue: [ startIndex := startIndex + 1 ].
	^ startIndex
]

{ #category : #'initialize-release' }
GtMethodCoder >> forClass: aBehavior source: aString [
	self classOrMetaClass: aBehavior.
	methodSource := aString
]

{ #category : #'initialize-release' }
GtMethodCoder >> forMethod: aCompiledMethod [
	self classOrMetaClass: aCompiledMethod methodClass.
	self selector: aCompiledMethod selector.
	methodSource := aCompiledMethod sourceCode
]

{ #category : #updating }
GtMethodCoder >> format [
	methodSource := self patternSource , String cr , (RBParser parseExpression: self bodySource) formattedCode copyReplaceAll: String cr with: String cr , String tab.
	self buildSource
]

{ #category : #ui }
GtMethodCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 10;
		stencil: [ self expanded: true ]
]

{ #category : #accessing }
GtMethodCoder >> highlighter [
	^ self attributeNamed: #highlighter
]

{ #category : #accessing }
GtMethodCoder >> highlighter: referenceHighlighter [
	self attributeNamed: #highlighter put: referenceHighlighter
]

{ #category : #'add ons' }
GtMethodCoder >> highlighterFor: anAST [
	<gtAstCoderAddOns: 10>
	self highlighter isNil
		ifTrue: [ addOns removeBodyStylerOfType: GtCoderReferenceStyler ]
		ifFalse: [ addOns addBodyStyler: (GtCoderReferenceStyler new highlighter: self highlighter) ]
]

{ #category : #'initialize-release' }
GtMethodCoder >> initialize [
	super initialize.
	announcer := Announcer new.
	methodSource := ''.
	expanded := false.
	self initializeAddOns
]

{ #category : #'initialize-release' }
GtMethodCoder >> initializeAddOns [
	addOns := GtMethodCoderAddOns new.
	addOns addPatternStyler: BrRBTextStyler new.
	addOns addBodyStyler: (BrRBMethodBodyTextStyler new methodPatternSource: self patternSource).
	addOns addMainAction: 'Save' translated icon: BrGlamorousIcons accept action: [ self save ].
	addOns clearChanges
]

{ #category : #testing }
GtMethodCoder >> isForMethod: aCompiledMethod [
	^ self classOrMetaClass = aCompiledMethod methodClass and: [ self selector = aCompiledMethod selector ]
]

{ #category : #testing }
GtMethodCoder >> isModified [
	^ methodSource ~= self newMethodSource
]

{ #category : #'actions - toolbar' }
GtMethodCoder >> mainActions [
	"Return a collection of main actions in the method coder, for example save"

	<return: #Collection of: #GtCoderAction>
	^ addOns mainActions
]

{ #category : #styling }
GtMethodCoder >> newBodyStyler [
	^ GtCoderBodyTextStyler forCoder: self
]

{ #category : #'instance creation' }
GtMethodCoder >> newCompletionStrategy [
	| completionStrategy ast |
	completionStrategy := GtPharoCompletionStrategy new.
	completionStrategy classOrMetaClass: self classOrMetaClass.
	[ ast := GtPharoParser parseWithErrors: self patternSource.
	completionStrategy methodPattern: ast pattern ]
		on: Error
		do: [ :ex | ex return ].
	^ completionStrategy
]

{ #category : #actions }
GtMethodCoder >> newMethodSource [
	^ self patternSource , String cr , self bodySource
]

{ #category : #private }
GtMethodCoder >> newPatternEditor [
	| editor |
	editor := BrTextEditor new.
	editor styler: self newPatternStyler.
	editor
		when: BrTextEditorInsertedEvent do: [ :event | self patternChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self patternChanged ];
		when: BlInfiniteDataSourceChanged do: [ :event | self patternChanged ].
	^ editor
]

{ #category : #styling }
GtMethodCoder >> newPatternStyler [
	^ GtCoderPatternTextStyler new
		coder: self;
		yourself
]

{ #category : #'instance creation' }
GtMethodCoder >> newSourceEditor [
	<return: #BrTextEditor>
	| aSourceEditor |
	aSourceEditor := BrTextEditor new.
	self newBodyStyler ifNotNil: [ :styler | aSourceEditor styler: styler ].
	aSourceEditor
		when: BrTextEditorDeletedEvent do: [ :event | self bodyChanged ];
		when: BrTextEditorInsertedEvent do: [ :event | self bodyChanged ];
		when: BlInfiniteDataSourceChanged do: [ :event | self bodyChanged ].
	aSourceEditor interactions add: (BlShortcut new
		combination: (BlKeyCombination builder primary; key: Key s; build);
		action: [ self save ]).
	aSourceEditor interactions add: (BlShortcut new
		combination: (BlKeyCombination builder primary; shift; key: Key f; build);
		action: [ self format ]).
	^ aSourceEditor
]

{ #category : #private }
GtMethodCoder >> nodeAtCursor [
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
GtMethodCoder >> object [
	^ self attributeNamed: #object
]

{ #category : #accessing }
GtMethodCoder >> object: anObject [
	self attributeNamed: #object put: anObject
]

{ #category : #'event handling' }
GtMethodCoder >> patternChanged [
	self clearSyntaxErrors: self patternEditor.
	self updateAddOns
]

{ #category : #private }
GtMethodCoder >> patternEditor [
	^ patternEditor ifNil: [ patternEditor := self newPatternEditor ]
]

{ #category : #accessing }
GtMethodCoder >> patternSource [
	^ self patternEditor text asString
]

{ #category : #accessing }
GtMethodCoder >> patternSource: aString [
	self patternEditor text: aString asRopedText
]

{ #category : #styling }
GtMethodCoder >> patternStylerForClass: stylerClass [
	| aStyler |
	aStyler := stylerClass new.
	aStyler classOrMetaClass: self classOrMetaClass.
	^ aStyler
]

{ #category : #accessing }
GtMethodCoder >> patternStylers [
	^ addOns patternStylers
]

{ #category : #private }
GtMethodCoder >> pragmasNamed: aSymbol inHierarchy: aClass [
	| actions |
	actions := OrderedCollection new.
	aClass withAllSubclassesDo: [ :each | actions addAll: (Pragma allNamed: aSymbol in: each) ].
	actions sort: [ :a :b | a arguments first < b arguments first ].
	^ actions
]

{ #category : #updating }
GtMethodCoder >> rbAST [
	^ [ | ast source |
	source := self newMethodSource.
	ast := RBParser parseFaultyMethod: source.
	ast methodNode
		compilationContext:
			(CompilationContext new
				class: (self classOrMetaClass ifNil: [ UndefinedObject ]);
				forSyntaxHighlighting: true;
				bindings: Dictionary new;
				requestor: nil).
	ast doSemanticAnalysis.
	ast ]
		on: Error
		do: [ :ex | ex return: nil ]
]

{ #category : #private }
GtMethodCoder >> referencesCoderAtCursor [
	| node |
	node := self nodeAtCursor.
	[ node isNil ]
		whileFalse: [ (node isKindOf: GtPharoVariableNode)
				ifTrue: [ ^ self referencesCoderForVariable: node name source ].
			(node isKindOf: GtPharoSymbolLiteralNode)
				ifTrue: [ ^ self referencesCoderForSymbol: node asSymbol ].
			(node isKindOf: GtPharoMessageSendNode)
				ifTrue: [ node := node message ].
			(node isKindOf: GtPharoMessageNode)
				ifTrue: [ ^ self referencesCoderForSymbol: node selector ].
			node := node parent ].
	^ nil
]

{ #category : #private }
GtMethodCoder >> referencesCoderForSymbol: aSymbol [
	^ (GtCoderMethodsCollection forReferences: aSymbol) asCoder
]

{ #category : #private }
GtMethodCoder >> referencesCoderForVariable: aString [
	| index binding methods |
	index := self classOrMetaClass instVarIndexFor: aString.
	index > 0
		ifTrue: [ methods := (self classOrMetaClass whichClassDefinesInstVar: aString) withAllSubclasses
				inject: OrderedCollection new
				into: [ :sum :each | 
					(each whichSelectorsAccess: aString) do: [ :sel | sum add: each >> sel ].
					sum ].
			^ (GtCoderMethodsCollection forClass: self classOrMetaClass andVariable: aString) asCoder ].
	binding := self classOrMetaClass bindingOf: aString.
	binding notNil
		ifTrue: [ ^ (GtCoderMethodsCollection forReferences: binding) asCoder ].
	^ nil
]

{ #category : #updating }
GtMethodCoder >> refreshForChanges [
	addOns
		changesDo: [ :each | 
			each = #bodyStylers
				ifTrue: [ self sourceEditor styleText ].
			each = #patternStylers
				ifTrue: [ self patternEditor styleText ].
			each = #mainActions
				ifTrue: [ self announce: (GtCoderMethodMainActionsChanged new coder: self) ].
			each = #contextActions
				ifTrue: [ self announce: (GtCoderMethodContextActionsChanged new coder: self) ] ].
	addOns clearChanges
]

{ #category : #actions }
GtMethodCoder >> renamePatternVariable: editorElement [
	GtCompositeRenameAction coderRenameLocalsOnPattern: editorElement source: self sourceEditor
]

{ #category : #actions }
GtMethodCoder >> renameSourceVariable: editorElement [
	GtCompositeRenameAction coderRenameLocalsOnSource: editorElement pattern: self patternEditor
]

{ #category : #private }
GtMethodCoder >> reportParseError: aString at: anInteger on: textEditor [
	| text position |
	text := textEditor text.
	position := anInteger - 1 max: 1.
	(text from: position to: position) attributes: {(GtMethodCoderErrorAttribute for: aString , ' ->')}.
	textEditor
		invalidate: position to: position;
		update: position to: position.
	textEditor moveCursorTo: position
]

{ #category : #actions }
GtMethodCoder >> requester [
	^ GtMethodCoderRequester on: self
]

{ #category : #examples }
GtMethodCoder >> runFrom: anElement [
	self isModified
		ifTrue: [ self save
				ifFalse: [ ^ self ] ].
	self exampleResult: self example run.
	self patternEditor styleText.
	self exampleResult isSuccess
		ifFalse: [ ^ self ].
	anElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: self exampleResult returnValue;
				sourceElement: anElement)
]

{ #category : #actions }
GtMethodCoder >> save [
	^ self validateSyntax and: [ self compile ]
]

{ #category : #private }
GtMethodCoder >> selectedSource [
	self selectedSourceInterval ifNotNil: [ :interval | ^ (self sourceEditor text from: interval first to: interval last) asString ].
	^ nil
]

{ #category : #private }
GtMethodCoder >> selectedSourceInterval [
	self sourceEditor selection do: [ :each | ^ each from + 1 to: each to ].
	^ nil
]

{ #category : #accessing }
GtMethodCoder >> selector [
	^ selector
]

{ #category : #accessing }
GtMethodCoder >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #private }
GtMethodCoder >> selectorAtCursor [
	^ self symbolFor: self nodeAtCursor
]

{ #category : #private }
GtMethodCoder >> skipBlankLinesIn: source at: startIndex [
	| char index |
	index := startIndex.
	[ index <= source size and: [ (char := source at: index) = Character cr or: [ char = Character lf ] ] ]
		whileTrue: [ index := index + 1 ].
	^ index
]

{ #category : #private }
GtMethodCoder >> sourceAst [
	^ GtPharoParser
		parseWithErrors: self sourceEditor text asString
		startingAt: GtPharoParser startingStateForMethodSequence
]

{ #category : #private }
GtMethodCoder >> sourceEditor [
	<return: #BrTextEditor>

	^ sourceEditor ifNil: [ sourceEditor := self newSourceEditor ]
]

{ #category : #private }
GtMethodCoder >> styledPatternTextFor: aString [
	| text |
	text := aString asRopedText.
	text monospace.
	^ BrRBTextStyler new
		classOrMetaClass: self classOrMetaClass;
		style: text
]

{ #category : #accessing }
GtMethodCoder >> subCoders [
	^ subCoders ifNil: [ subCoders := OrderedCollection new ]
]

{ #category : #private }
GtMethodCoder >> symbolFor: aNode [
	| current |
	aNode isNil
		ifTrue: [ ^ nil ].
	(aNode isKindOf: GtPharoSymbolLiteralNode)
		ifTrue: [ aNode asSymbol ].
	current := aNode.
	[ current notNil ]
		whileTrue: [ (current isKindOf: GtPharoMessageSendNode)
				ifTrue: [ current := current message ].
			(current isKindOf: GtPharoMessageNode)
				ifTrue: [ ^ current selector ].
			current := current parent ].
	^ nil
]

{ #category : #updating }
GtMethodCoder >> updateAddOns [
	| pragmas ast |
	ast := self rbAST.
	pragmas := self pragmasNamed: #gtAstCoderAddOns: inHierarchy: self class.
	pragmas reverseDo: [ :each | self perform: each methodSelector with: ast ].
	self refreshForChanges
]

{ #category : #'event handling' }
GtMethodCoder >> updateMethod: aCompiledMethod [
	self forMethod: aCompiledMethod.
	self buildSource
]

{ #category : #private }
GtMethodCoder >> updateStylerPattern [
	self sourceEditor styler methodPatternSource: self patternEditor text asString.
	self sourceEditor styleText
]

{ #category : #private }
GtMethodCoder >> validateSyntax [
	subCoders notNil
		ifTrue: [ subCoders
				do: [ :each | 
					each validateSyntax
						ifFalse: [ ^ false ] ] ].
	[ GtPharoParser parse: self patternSource startingAt: GtPharoParser startingStateForMethodPattern ]
		on: SmaCCParserError
		do: [ :ex | 
			self reportParseError: ex messageText at: ex tag position on: self patternEditor.
			^ false ].
	[ GtPharoParser parse: self bodySource startingAt: GtPharoParser startingStateForMethodSequence ]
		on: SmaCCParserError
		do: [ :ex | 
			self reportParseError: ex messageText at: ex tag position on: self sourceEditor.
			^ false ].
	^ true
]

{ #category : #private }
GtMethodCoder >> variableAtCursor [
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
