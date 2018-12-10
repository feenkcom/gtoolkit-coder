Class {
	#name : #GtMethodCoder,
	#superclass : #GtSourceCoder,
	#instVars : [
		'class',
		'selector',
		'methodSource',
		'subCoders',
		'isBuilt',
		'astCache'
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

{ #category : #'instance creation' }
GtMethodCoder class >> newMethod [
	^ self new
		expanded: true;
		source: '';
		yourself
]

{ #category : #elements }
GtMethodCoder >> addShortcutsTo: editorElement [
	addOns shortcuts
		do: [ :each | editorElement addShortcut: (each copy action: [ each action cull: editorElement ]) ]
]

{ #category : #accessing }
GtMethodCoder >> addSubCoder: aMethodCoder [
	self subCoders addFirst: aMethodCoder
]

{ #category : #elements }
GtMethodCoder >> asElement [
	self ensureBuilt.
	^ GtCoderMethodElement new methodCoder: self
]

{ #category : #private }
GtMethodCoder >> buildSource [
	isBuilt := true.
	[ | text |
	text := methodSource asRopedText.
	text attributes: self defaultTextAttributes.
	self sourceEditor text: text ]
		on: Error
		do: [ :ex | ex return ]
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
	self collapsedText clearAttributes: [ :each | each isKindOf: GtMethodCoderErrorAttribute ]
]

{ #category : #private }
GtMethodCoder >> collapsedStyler [
	^ self newSourceStyler
]

{ #category : #accessing }
GtMethodCoder >> collapsedText [
	self ensureBuilt.
	^ super collapsedText
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
GtMethodCoder >> ensureBuilt [
	isBuilt
		ifTrue: [ ^ self ].
	self buildSource
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
		ifFalse: [ addOns removeStylerOfType: GtCoderExpandableExampleStyler.
			addOns removeStylerOfType: GtCoderExampleStatusStyler.
			addOns removeContextAction: 'Run' translated.
			^ self ].
	addOns addStyler: GtCoderExpandableExampleStyler new.
	addOns
		addStyler:
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
	methodSource := aString.
	isBuilt
		ifTrue: [ self buildSource ]
]

{ #category : #'initialize-release' }
GtMethodCoder >> forMethod: aCompiledMethod [
	self classOrMetaClass: aCompiledMethod methodClass.
	self selector: aCompiledMethod selector.
	methodSource := aCompiledMethod sourceCode.
	isBuilt
		ifTrue: [ self buildSource ]
]

{ #category : #updating }
GtMethodCoder >> format [
	methodSource := (RBParser parseMethod: self source) formattedCode.
	self buildSource
]

{ #category : #ui }
GtMethodCoder >> gtLiveFor: aView [
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
		ifTrue: [ addOns removeStylerOfType: GtCoderReferenceStyler ]
		ifFalse: [ addOns addStyler: (GtCoderReferenceStyler new highlighter: self highlighter) ]
]

{ #category : #'initialize-release' }
GtMethodCoder >> initialize [
	isBuilt := false.
	super initialize.
	methodSource := ''.
	astCache := nil -> nil
]

{ #category : #'initialize-release' }
GtMethodCoder >> initializeAddOns [
	super initializeAddOns.
	addOns addStyler: BrRBTextStyler new.
	addOns addMainAction: 'Save' translated icon: BrGlamorousIcons accept action: [ self save ].
	addOns clearChanges
]

{ #category : #'initialize-release' }
GtMethodCoder >> initializeShortcuts [
	super initializeShortcuts.
	addOns
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
				action: [ :editorElement | self doItAndGoSelection: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key r;
						build);
				action: [ :editorElement | self renameVariableIn: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key e;
						build);
				action: [ :editorElement | self extractMethod: editorElement ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						key: Key s;
						build);
				action: [ self save ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						shift;
						key: Key f;
						build);
				action: [ self format ])
]

{ #category : #testing }
GtMethodCoder >> isForMethod: aCompiledMethod [
	^ self classOrMetaClass = aCompiledMethod methodClass and: [ self selector = aCompiledMethod selector ]
]

{ #category : #testing }
GtMethodCoder >> isModified [
	^ methodSource ~= self newMethodSource
]

{ #category : #actions }
GtMethodCoder >> newMethodSource [
	self ensureBuilt.
	^ self source
]

{ #category : #'instance creation' }
GtMethodCoder >> newSourceEditor [
	<return: #BrTextEditor>
	| aSourceEditor |
	aSourceEditor := super newSourceEditor.
	aSourceEditor when: BlInfiniteDataSourceChanged do: [ :event | self sourceChanged ].
	^ aSourceEditor
]

{ #category : #styling }
GtMethodCoder >> newSourceStyler [
	^ GtCoderTextStyler forCoder: self
]

{ #category : #accessing }
GtMethodCoder >> object [
	^ self attributeNamed: #object
]

{ #category : #accessing }
GtMethodCoder >> object: anObject [
	self attributeNamed: #object put: anObject
]

{ #category : #private }
GtMethodCoder >> parserStartingState [
	^ GtPharoParser startingStateForMethod
]

{ #category : #private }
GtMethodCoder >> patternSource [
	^ String
		streamContents: [ :stream | 
			| ast selectorParts arguments |
			ast := self rbAST.
			selectorParts := ast selectorParts.
			arguments := ast arguments.
			(selectorParts size = 1 and: [ arguments isEmpty ])
				ifTrue: [ stream nextPutAll: selectorParts first ]
				ifFalse: [ 1 to: selectorParts size do: [ :i | 
						i = 1
							ifFalse: [ stream space ].
						stream
							nextPutAll: (selectorParts at: i);
							space;
							nextPutAll: (arguments at: i) name ] ] ]
]

{ #category : #updating }
GtMethodCoder >> rbAST [
	| source |
	source := self newMethodSource.
	astCache key = source
		ifTrue: [ ^ astCache value ].
	^ [ | ast |
	ast := RBParser parseFaultyMethod: source.
	ast methodNode
		compilationContext:
			(CompilationContext new
				class: (self classOrMetaClass ifNil: [ UndefinedObject ]);
				forSyntaxHighlighting: true;
				bindings: Dictionary new;
				requestor: nil).
	ast doSemanticAnalysis.
	astCache := source -> ast.
	ast ]
		on: Error
		do: [ :ex | ex return: nil ]
]

{ #category : #updating }
GtMethodCoder >> refreshForChanges [
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

{ #category : #accessing }
GtMethodCoder >> removeSubCoder: aMethodCoder [
	self subCoders remove: aMethodCoder ifAbsent: [  ]
]

{ #category : #actions }
GtMethodCoder >> renameVariableIn: editorElement [
	GtRenameAction pharoRenameLocalsOn: editorElement
]

{ #category : #examples }
GtMethodCoder >> runFrom: anElement [
	self isModified
		ifTrue: [ self save
				ifFalse: [ ^ self ] ].
	self exampleResult: self example run.
	self styleCollapsedText.
	self styleSourceText.
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

{ #category : #accessing }
GtMethodCoder >> selector [
	^ selector
]

{ #category : #accessing }
GtMethodCoder >> selector: aSymbol [
	selector := aSymbol
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
GtMethodCoder >> styledPatternTextFor: aString [
	| text |
	text := aString asRopedText.
	text attributes: self defaultTextAttributes.
	text := BrRBTextStyler new
		classOrMetaClass: self classOrMetaClass;
		style: text.
	text attributes: self disabledTextAttributes.
	^ text
]

{ #category : #accessing }
GtMethodCoder >> stylers [
	^ addOns stylers
]

{ #category : #accessing }
GtMethodCoder >> subCoders [
	^ subCoders ifNil: [ subCoders := OrderedCollection new ]
]

{ #category : #updating }
GtMethodCoder >> updateAddOns [
	| pragmas ast |
	ast := self rbAST.
	pragmas := self pragmasNamed: #gtAstCoderAddOns: inHierarchy: self class.
	pragmas reverseDo: [ :each | self perform: each methodSelector with: ast ].
	self refreshForChanges
]

{ #category : #private }
GtMethodCoder >> updateCollapsedSource [
	[ | patternText |
	patternText := self patternSource asRopedText.
	patternText attributes: self defaultTextAttributes.
	self collapsedSource: patternText ]
		on: Error
		do: [ :ex | super updateCollapsedSource ]
]

{ #category : #'event handling' }
GtMethodCoder >> updateMethod: aCompiledMethod [
	self forMethod: aCompiledMethod.
	self buildSource
]

{ #category : #private }
GtMethodCoder >> updateStylerPattern [
	self sourceEditor styler methodPatternSource: self collapsedSource.
	self sourceEditor styleText
]

{ #category : #private }
GtMethodCoder >> validateSyntax [
	subCoders notNil
		ifTrue: [ subCoders
				do: [ :each | 
					each validateSyntax
						ifFalse: [ ^ false ] ] ].
	^ super validateSyntax
]
