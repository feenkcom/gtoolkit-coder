"
! Method Coder
I extend a ${class:GtSourceCoder}$ with the knowledge of how to edit a method. In particular, I am aware of different types of methods and provide a wider variety of refactorings and actions. 
!! Refactorings

!!! What is the difference between ${method:GtMethodCoder>>#selector}$ and ${method:GtMethodCoder>>#currentSelector}$
"
Class {
	#name : #GtMethodCoder,
	#superclass : #GtSourceCoder,
	#instVars : [
		'methodBehavior',
		'selector'
	],
	#classVars : [
		'NodeHighlight'
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
	^ self new
		forExample: anExample;
		yourself
]

{ #category : #'instance creation' }
GtMethodCoder class >> forMethod: aCompiledMethod [
	^ self new
		forMethod: aCompiledMethod;
		yourself
]

{ #category : #'instance creation' }
GtMethodCoder class >> forNewMethod: aBehavior [
	^ self forClass: aBehavior source: ''
]

{ #category : #'instance creation' }
GtMethodCoder class >> forObject: anObject andSelector: aSymbol [
	^ (self forMethod: anObject class >> aSymbol)
		object: anObject;
		yourself
]

{ #category : #accessing }
GtMethodCoder class >> nodeHighlight [
	^ NodeHighlight
		ifNil: [ NodeHighlight := BlTextHighlightAttribute new
				paint: BrGlamorousColors textHighlightColor ]
]

{ #category : #'api - refactorings' }
GtMethodCoder >> abstractClassVar: aNode [
	| refactoring model cls |
	model := self createRefactoringModel.
	cls := (model classFor: self classOrMetaClass) instanceSide.
	refactoring := RBAbstractClassVariableRefactoring
		model: model
		variable: aNode name
		class: (cls whoDefinesClassVariable: aNode name).
	self addRefactoringChangesPreview: refactoring at: aNode stop
]

{ #category : #'api - refactorings' }
GtMethodCoder >> abstractInstVar: aNode [
	| refactoring model cls |
	model := self createRefactoringModel.
	cls := model classFor: self classOrMetaClass.
	refactoring := RBAbstractInstanceVariableRefactoring
		model: model
		variable: aNode name
		class: (cls whoDefinesInstanceVariable: aNode name).
	self addRefactoringChangesPreview: refactoring at: aNode stop
]

{ #category : #'private - addons' }
GtMethodCoder >> addClassAccessorRefactoringsFor: aNode to: coderAddOns [
	aNode isVariable
		ifFalse: [ ^ self ].
	(aNode whoDefines: aNode name) notNil
		ifTrue: [ ^ self ].
	(self classOrMetaClass allClassVarNames includes: aNode name asSymbol)
		ifFalse: [ ^ self ].
	coderAddOns
		addContextMenuItem: (self createLabel: 'Abstract variable' description: aNode name)
		hover: [ self highlightNode: aNode ]
		leave: [ self removeHighlight ]
		action: [ :element | self abstractClassVar: aNode ].
	(self isAccessorMethodFor: aNode)
		ifFalse: [ coderAddOns
				addContextMenuItem: (self createLabel: 'Create accessors' description: aNode name)
				hover: [ self highlightNode: aNode ]
				leave: [ self removeHighlight ]
				action: [ :element | self createAccessorsFor: aNode instanceVariable: false ] ]
]

{ #category : #'api - refactorings' }
GtMethodCoder >> addClassVariable: aString [
	| refactoring |

	refactoring := RBAddClassVariableRefactoring
		variable: aString
		class: self classOrMetaClass instanceSide.
	refactoring execute.
	
	"Need to reset AST for undeclared variables"
	self resetASTCache.
	
	"and restyle the text"
	self requestStyleSourceText
]

{ #category : #'private - addons' }
GtMethodCoder >> addExtractMethodTo: coderAddOns from: anEditorElement [
	| nodes |
	nodes := self rbSelectedNodesFrom: anEditorElement.
	nodes isNil
		ifTrue: [ ^ self ].
	coderAddOns
		addContextMenuItem: 'Extract method'
		hover: [ self highlightFrom: nodes first start to: nodes last stop ]
		leave: [ self removeHighlight ]
		action: [ :element | self extractMethod: element ]
]

{ #category : #'private - addons' }
GtMethodCoder >> addExtractTempFor: aNode to: coderAddOns [
	aNode isValue
		ifFalse: [ ^ self ].
	aNode isUsed
		ifFalse: [ ^ self ].
	aNode isVariable
		ifTrue: [ ^ self ].
	aNode isAssignment
		ifTrue: [ ^ self ].
	aNode parent isAssignment
		ifTrue: [ ^ self ].
	coderAddOns
		addContextMenuItem:
			(self
				createLabel: 'Extract temporary'
				description: (self nodeDescription: aNode))
		hover: [ self highlightNode: aNode ]
		leave: [ self removeHighlight ]
		action: [ :element | self extractTemporaryVariable: aNode in: element ]
]

{ #category : #'private - addons' }
GtMethodCoder >> addInlineSelfMessageFor: aNode to: coderAddOns [
	aNode isMessage
		ifFalse: [ ^ self ].
	aNode receiver isSelf
		ifFalse: [ ^ self ].
	coderAddOns
		addContextMenuItem: (self createLabel: 'Inline Message' description: aNode selector)
		hover: [ self highlightNode: aNode ]
		leave: [ self removeHighlight ]
		action: [ :element | self inlineMessageSendIn: aNode ]
]

{ #category : #'private - addons' }
GtMethodCoder >> addInlineTempFor: aNode to: coderAddOns [
	aNode isAssignment
		ifFalse: [ ^ self ].
	aNode variable gtIsLocal
		ifFalse: [ ^ self ].
	coderAddOns
		addContextMenuItem:
			(self
				createLabel: 'Inline Assignment'
				description: aNode variable name)
		hover: [ self highlightNode: aNode ]
		leave: [ self removeHighlight ]
		action: [ :element | self inlineTemporaryVariableIn: aNode ]
]

{ #category : #'private - addons' }
GtMethodCoder >> addInstanceAccessorRefactoringsFor: aNode to: coderAddOns [
	aNode isVariable
		ifFalse: [ ^ self ].
	(aNode whoDefines: aNode name) notNil
		ifTrue: [ ^ self ].
	(self classOrMetaClass allInstVarNames includes: aNode name)
		ifFalse: [ ^ self ].
	coderAddOns
		addContextMenuItem: (self createLabel: 'Abstract variable' description: aNode name)
		hover: [ self highlightNode: aNode ]
		leave: [ self removeHighlight ]
		action: [ :element | self abstractInstVar: aNode ].
	(self isAccessorMethodFor: aNode)
		ifTrue: [ coderAddOns
				addContextMenuItem: (self createLabel: 'Protect variable' description: aNode name)
				hover: [ self highlightNode: aNode ]
				leave: [ self removeHighlight ]
				action: [ :element | self protectInstVar: aNode ] ]
		ifFalse: [ coderAddOns
				addContextMenuItem: (self createLabel: 'Create accessors' description: aNode name)
				hover: [ self highlightNode: aNode ]
				leave: [ self removeHighlight ]
				action: [ :element | self createAccessorsFor: aNode instanceVariable: true ] ]
]

{ #category : #'api - refactorings' }
GtMethodCoder >> addInstanceVariable: aString [
	| refactoring |
	refactoring := RBAddInstanceVariableRefactoring
		variable: aString
		class: self behavior.
	refactoring execute.
	self resetASTCache.	"Need to reset AST for undeclared variables"
	self requestStyleSourceText
]

{ #category : #'private - addons' }
GtMethodCoder >> addRefactoringContextMenuAddOnsTo: coderAddOns from: anEditorElement [
	<gtCoderContextMenuAddOns: 20>
	self addExtractMethodTo: coderAddOns from: anEditorElement.
	(self rbSelectedNodeFrom: anEditorElement)
		ifNotNil: [ :ast | 
			self addInstanceAccessorRefactoringsFor: ast to: coderAddOns.
			self addClassAccessorRefactoringsFor: ast to: coderAddOns.
			self addRemoveParameterRefactoringFor: ast to: coderAddOns.
			ast
				withAllParentsDo: [ :node | self addInlineSelfMessageFor: node to: coderAddOns ].
			ast
				withAllParentsDo: [ :node | self addInlineTempFor: node to: coderAddOns ].
			ast
				withAllParentsDo: [ :node | self addExtractTempFor: node to: coderAddOns ] ]
]

{ #category : #'private - addons' }
GtMethodCoder >> addRemoveParameterRefactoringFor: aNode to: coderAddOns [
	aNode isVariable
		ifFalse: [ ^ self ].
	aNode parent isMethod
		ifFalse: [ ^ self ].
	aNode parent body
		nodesDo: [ :each | 
			each = aNode
				ifTrue: [ ^ self ] ].
	coderAddOns
		addContextMenuItem: (self createLabel: 'Remove parameter' description: aNode name)
		hover: [ self highlightNode: aNode ]
		leave: [ self removeHighlight ]
		action: [ :element | self removeParameter: aNode ]
]

{ #category : #'api - accessing' }
GtMethodCoder >> behavior [
	<return: #GtMethodCoderBehavior>

	self methodBehavior isClass
		ifTrue: [ ^ self methodBehavior ].

	self methodBehavior realBehaviorDo: [ :aBehavior | ^ aBehavior ].
	^ UndefinedObject
]

{ #category : #'api - accessing' }
GtMethodCoder >> behavior: aBehavior [
	self methodBehavior: (GtMethodCoderExplicitBehavior new behavior: aBehavior)
]

{ #category : #testing }
GtMethodCoder >> canCompileMethodIn: newClass [
	| ast modelClass pools variables model |
	ast := self rbAST.
	variables := Set new.
	ast
		nodesDo: [ :node | 
			(node isSelfOrSuper not
				and: [ node isVariable and: [ node gtIsLocal not ] ])
				ifTrue: [ variables add: node name ] ].
	model := RBNamespace new.
	modelClass := model classFor: newClass.
	pools := {Smalltalk} , modelClass instanceSide sharedPools.
	^ variables
		allSatisfy: [ :each | 
			(modelClass definesVariable: each)
				or: [ pools anySatisfy: [ :pool | pool includesKey: each asSymbol ] ] ]
]

{ #category : #'api - actions examples' }
GtMethodCoder >> canExecuteExample [
	<return: #Boolean>

	^ self example
		ifNil: [ false ]
		ifNotNil: [ :anExample | anExample canBeExecuted ]
]

{ #category : #testing }
GtMethodCoder >> canMoveMethodToInstanceOrClass [
	| oldClass newClass |
	oldClass := self behavior.
	newClass := oldClass isMeta
		ifTrue: [ oldClass soleInstance ]
		ifFalse: [ oldClass class ].
	(newClass includesSelector: self currentSelector)
		ifTrue: [ ^ false ].
	^ self canCompileMethodIn: newClass
]

{ #category : #'api - accessing' }
GtMethodCoder >> category [
	self
		deprecated: 'Use #protocol instead.'
		transformWith: '`@receiver category' -> '`@receiver protocol'.

	^ self protocol
]

{ #category : #'api - accessing' }
GtMethodCoder >> category: aSymbol [
	self
		deprecated: 'Use #protocol: instead.'
		transformWith: '`@receiver category: `@arg' -> '`@receiver protocol: `@arg'.

	self protocol: aSymbol
]

{ #category : #'private - actions' }
GtMethodCoder >> changeManager [
	^ RBRefactoryChangeManager instance
]

{ #category : #private }
GtMethodCoder >> changedSourceForCurrentMethod: aRefactoryChange [
	aRefactoryChange changes
		reverseDo: [ :each | 
			((each isKindOf: RBAddMethodChange)
				and: [ each selector = self currentSelector
						and: [ self classOrMetaClass = each changeClass ] ])
				ifTrue: [ ^ each source ] ].
	^ nil
]

{ #category : #accessing }
GtMethodCoder >> classOrMetaClass: aBehavior [
	self
		deprecated: 'Use #behavior: instead.'
		transformWith: '`@receiver classOrMetaClass: `@arg' -> '`@receiver behavior: `@arg'.

	self behavior: aBehavior
]

{ #category : #'private - actions' }
GtMethodCoder >> clearExample [
	self unsubscribeFromExample.
	self removeAttributeNamed: #example.
]

{ #category : #private }
GtMethodCoder >> compilationRequester [
	^ GtSourceCoderCompilationRequester new coder: self
]

{ #category : #'api - actions' }
GtMethodCoder >> compile [
	"Try to compile the current source code and return true if it was successful, false otherwise"
	<return: #Boolean>

	"we should use #currentSelector instead of #selector because we care
	about the `current` state of the coder (#selector may be nil for new methods)"
	self currentSelector
		ifNil: [ ^ false ].

	^ self methodBehavior
		realBehaviorDo: [ :aBehavior |
			| aChange |
			aChange := self createCompileMethodChangeIn: aBehavior.

			selector := aChange selector.

			(self
				handleCompilerErrorsDuring: [ self changeManager performChange: aChange ])
				ifFalse: [ ^ false ].

			aChange definedSelector
				ifNotNil: [ :sel | 
					self selector: sel.
					self compiledMethod
						ifNotNil: [ :method |
							self forMethod: method.
							^ true ] ].
			false ]
		ifAbsent: [ false ]
]

{ #category : #accessing }
GtMethodCoder >> compiledMethod [
	<return: #CompiledMethod or: nil>
	
	^ self existsInTheSystem
		ifTrue: [ self behavior >> self selector ]
		ifFalse: [ nil ]
]

{ #category : #'api - refactorings' }
GtMethodCoder >> createAccessorsFor: aNode instanceVariable: aBoolean [
	| refactoring model cls |
	model := self createRefactoringModel.
	cls := (model classFor: self classOrMetaClass) instanceSide.
	refactoring := RBCreateAccessorsForVariableRefactoring
		model: model
		variable: aNode name
		class:
			(aBoolean
				ifTrue: [ cls whoDefinesInstanceVariable: aNode name ]
				ifFalse: [ cls whoDefinesClassVariable: aNode name ])
		classVariable: aBoolean not.
	self addRefactoringChangesPreview: refactoring at: aNode stop
]

{ #category : #private }
GtMethodCoder >> createCompileMethodChange [
	<return: #RBAddMethodChange or: nil>

	^ self methodBehavior
		realBehaviorDo: [ :aBehavior | self createCompileMethodChangeIn: aBehavior ]
		ifAbsent: [ nil ]
]

{ #category : #private }
GtMethodCoder >> createCompileMethodChangeIn: aBehavior [
	<return: #RBAddMethodChange>

	^ self protocol
		ifNil: [
			RBAddMethodChange
				compile: self currentSourceString
				in: aBehavior
				for: self compilationRequester ]
		ifNotNil: [ :aCategory | 
			RBAddMethodChange
				compile: self currentSourceString
				in: aBehavior
				classified: aCategory
				for: self compilationRequester ]
]

{ #category : #'private - refactorings' }
GtMethodCoder >> createLabel: aString description: description [
	^ aString asRopedText
		,
			((' ' , description) asRopedText
				attributes:
					{(BlFontSizeAttribute size: 12).
					(BlTextForegroundAttribute paint: Color gray)})
]

{ #category : #private }
GtMethodCoder >> createRefactoringModel [
	| model |
	model := RBClassModelFactory rbNamespace
		onEnvironment: RBBrowserEnvironment new.
	(((model classFor: self classOrMetaClass)
		directlyDefinesMethod: self currentSelector) not
		or: [ ((model classFor: self classOrMetaClass)
				sourceCodeFor: self currentSelector)
				~= self sourceText asString ])
		ifTrue: [ (model classFor: self classOrMetaClass)
				compile: self sourceText asString
				classified: self category ].
	^ model
]

{ #category : #accessing }
GtMethodCoder >> currentSelector [
	^ selector
		ifNil: [ self rbAST
				ifNotNil: [ :ast | 
					ast isMethod
						ifTrue: [ ast selector ] ] ]
]

{ #category : #'api - actions' }
GtMethodCoder >> debug [
	self isModified ifTrue: [
		self save
			ifFalse: [ ^ self ] ].

	self class
		debug: self compiledMethod
		receiver: self object
		in: self context
]

{ #category : #'api - actions examples' }
GtMethodCoder >> debugExample [
	self isModified
		ifTrue: [ self save
			ifFalse: [ ^ self ] ].
	self example openingDebugger result
]

{ #category : #'private - actions' }
GtMethodCoder >> evaluateSelector: aSymbol object: anObject [
	^ self
		evaluateSelector: aSymbol
		object: anObject
		thenDo: [ ]
]

{ #category : #'private - actions' }
GtMethodCoder >> evaluateSelector: aSymbol object: anObject thenDo: aThenBlock [
	"Evaluate a given source code and show the print string if needed"

	^ self critical: [
		| aResult aReceiver aSourceString |

		aReceiver := (anObject respondsTo: aSymbol)
			ifTrue: [ anObject ]
			ifFalse: [ anObject class ].
			
		aSourceString := self currentSourceString.

		aResult := self evaluateBlock: [ aReceiver perform: aSymbol ]
			onErrorDo: [ :aResultWithError |
				aResultWithError
					sourceString: aSourceString;
					sourceInterval: (1 to: aSourceString size) ].

		aResult
			sourceString: aSourceString;
			sourceInterval: (1 to: aSourceString size).

		self notifyEvaluatedWithResult: aResult.
		aThenBlock cull: aResult.
		aResult ]
]

{ #category : #'api - actions examples' }
GtMethodCoder >> example [
	<return: #GtExampleWithResult or: nil>
	| anExample |
	anExample := self attributeNamed: #example.
	anExample ifNil: [ 
		anExample := self compiledMethod ifNotNil: [ :aCompiledMethod | 
			aCompiledMethod gtExample ifNotNil: #asExampleWithResult ].
		anExample ifNotNil: [ self example: anExample ] ].
	^ anExample
]

{ #category : #'api - actions examples' }
GtMethodCoder >> example: anExampleWithResult [
	| aCompiledMethod |
	self unsubscribeFromExample.
	self
		attributeNamed: #example
		put: anExampleWithResult asExampleWithResult.
	aCompiledMethod := anExampleWithResult method.
	(aCompiledMethod selector = self selector
		and: [ aCompiledMethod methodClass = self behavior ])
		ifFalse: [ self error: 'Can not assign example of the wrong method' ].
	self example announcer
		when: GtExampleExecuted send: #handleExampleExecuted: to: self;
		when: GtExampleArgumentsChanged
			send: #handleExampleArgumentsChanged:
			to: self
]

{ #category : #'api - actions examples' }
GtMethodCoder >> exampleResult [
	<return: #GtExampleResult or: nil>
	^ self example ifNotNil: #result
]

{ #category : #testing }
GtMethodCoder >> existsInTheSystem [
	"Return true if a method with the given #selector exists in the behavior"
	<return: #Boolean>

	self behavior
		ifNil: [ ^ false ].

	self behavior isObsolete
		ifTrue: [ ^ false ].

	self selector
		ifNil: [ ^ false ].

	^ self behavior includesSelector: self selector
]

{ #category : #accessing }
GtMethodCoder >> explanationLink [
	^ self attributeNamed: #explanationLink
]

{ #category : #accessing }
GtMethodCoder >> explanationLink: anExplanation [
	self explanationLink == anExplanation
		ifTrue: [ ^ self ].

	self attributeNamed: #explanationLink put: anExplanation.
	
	self requestStyleSourceText.
	self requestUpdateAddOns
]

{ #category : #'api - refactorings' }
GtMethodCoder >> extractMethod: editorElement [
	(GtExtractMethodController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #'api - refactorings' }
GtMethodCoder >> extractTemporaryVariable: aNode in: anEditorElement [
	| refactoring model tempName |
	model := self createRefactoringModel.
	tempName := self safeTemporaryName.
	refactoring := RBExtractToTemporaryRefactoring
		model: model
		extract: aNode sourceInterval
		to: tempName
		from: self currentSelector
		in: (model classFor: self classOrMetaClass).
	(self performMethodRefactoring: refactoring)
		ifFalse: [ ^ self ].
	(self findNodeAssigning: tempName)
		ifNotNil: [ :node | 
			anEditorElement editor moveCursorTo: node stop.
			self renameLocalVariableIn: anEditorElement ]
]

{ #category : #'private - refactorings' }
GtMethodCoder >> findNodeAssigning: aString [
	self rbAST
		nodesDo: [ :each | 
			(each isAssignment and: [ each variable name = aString ])
				ifTrue: [ ^ each variable ] ].
	^ nil
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

{ #category : #initialize }
GtMethodCoder >> forClass: aBehavior source: aString [
	self behavior: aBehavior.
	self sourceCode: (GtCoderExplicitSourceCode new source: aString)
]

{ #category : #initialize }
GtMethodCoder >> forExample: anExampleWithResult [
	self forMethod: anExampleWithResult method.
	self example: anExampleWithResult
]

{ #category : #initialize }
GtMethodCoder >> forMethod: aCompiledMethod [
	self methodBehavior: (GtMethodCoderExplicitBehavior new behavior: aCompiledMethod methodClass).
	self selector: aCompiledMethod selector.
	self sourceCode: (GtCoderCompiledMethodSourceCode new compiledMethod: aCompiledMethod).
	self protocol: aCompiledMethod category
]

{ #category : #'api - actions' }
GtMethodCoder >> format [
	| ast |
	ast := [ RBParser parseMethod: self currentSourceString ]
		on: SyntaxErrorNotification
		do: [ :ex | 
			^ self
				notifyParseError: ex errorMessage
				at: ex location ].
			
	self currentSourceString: ast formattedCode.
]

{ #category : #'gt-extensions' }
GtMethodCoder >> gtDiffViewFor: aView [
	"<gtView>
	(methodSource = self newMethodSource) ifTrue: [ ^ aView ].
	^ aView textEditor
		title: 'Diff' translated;
		priority: 11;
		text: [ :anEditor | 
			GtEpiceaDiffStencil new
				from: methodSource;
				to: self newMethodSource;
				create ]"
]

{ #category : #private }
GtMethodCoder >> handleCompilerErrorsDuring: aBlock [
	^ [
			aBlock value.
			true ]
		on: OCSemanticWarning
		do: [ :ex | 
			self
				notifyParseError: ex errorMessage
				at: ex location.
			ex return: false ]
]

{ #category : #'examples - event handling' }
GtMethodCoder >> handleExampleArgumentsChanged: aGtExampleArgumentsChanged [
	self requestUpdateAddOns
]

{ #category : #'examples - event handling' }
GtMethodCoder >> handleExampleExecuted: aGtExampleExecuted [
	self requestStyleSourceText.
	self announce: (GtCoderExampleExecuted new 
		coder: self;
		example: aGtExampleExecuted example)
]

{ #category : #'private - refactorings' }
GtMethodCoder >> highlightFrom: startIndex to: endIndex [
	(self sourceText from: startIndex to: endIndex)
		attributes: { self class nodeHighlight }
]

{ #category : #'private - refactorings' }
GtMethodCoder >> highlightNode: aNode [
	self highlightFrom: aNode start to: aNode stop
]

{ #category : #accessing }
GtMethodCoder >> highlighter [
	<return: #GtSourceReferenceHighlighter>

	^ self attributeNamed: #highlighter
]

{ #category : #accessing }
GtMethodCoder >> highlighter: aGtSourceReferenceHighlighter [
	"Set a source reference highlighter thhat should be used tp highlight or mark some parts
	of the source code. If a given highlighter is nil, it means that no highlighter should be used"

	self highlighter == aGtSourceReferenceHighlighter
		ifTrue: [ ^ self ].

	self
		attributeNamed: #highlighter
		put: aGtSourceReferenceHighlighter.

	self requestUpdateAddOns.
	self requestStyleSourceText
]

{ #category : #initialize }
GtMethodCoder >> initializeShortcuts [
	super initializeShortcuts.

	addOns
		addShortcut: GtSourceCoderPlayShortcut new;
		addShortcut: GtSourceCoderPlayAndInspectShortcut new;
		addShortcut: GtSourceCoderRenameShortcut new;
		addShortcut: GtSourceCoderExtractMethodShortcut new;
		addShortcut: GtSourceCoderSaveShortcut new;
		addShortcut: GtSourceCoderFormatShortcut new
]

{ #category : #'api - refactorings' }
GtMethodCoder >> inlineMessageSendIn: messageNode [
	| refactoring model |
	model := self createRefactoringModel.
	refactoring := RBInlineMethodRefactoring
		model: model
		inline: messageNode sourceInterval
		inMethod: self currentSelector
		forClass: (model classFor: self classOrMetaClass).
	refactoring
		setOption: #inlineExpression
		toUse: [ :ref :string | true ].
	self performMethodRefactoring: refactoring
]

{ #category : #'api - refactorings' }
GtMethodCoder >> inlineTemporaryVariableIn: assignmentNode [
	| refactoring model |
	model := self createRefactoringModel.
	refactoring := RBInlineTemporaryRefactoring
		model: model
		inline: assignmentNode sourceInterval
		from: self currentSelector
		in: (model classFor: self classOrMetaClass).
	self performMethodRefactoring: refactoring
]

{ #category : #'private - refactorings' }
GtMethodCoder >> isAccessorMethodFor: aNode [
	| statement |
	aNode methodNode body statements size = 1
		ifFalse: [ ^ false ].
	aNode methodNode body temporaries isEmpty
		ifFalse: [ ^ false ].
	aNode parent isReturn
		ifTrue: [ statement := aNode parent.
			^ statement parent isSequence
				and: [ statement parent parent == aNode methodNode
						and: [ aNode methodNode selector isUnary ] ] ].
	aNode parent isAssignment
		ifFalse: [ ^ false ].
	(aNode methodNode selector numArgs = 1
		and: [ aNode parent value = aNode methodNode arguments first ])
		ifFalse: [ ^ false ].
	statement := aNode parent.
	statement parent isReturn
		ifTrue: [ statement := statement parent ].
	^ statement parent isSequence
		and: [ statement parent parent == aNode methodNode ]
]

{ #category : #testing }
GtMethodCoder >> isForMethod [
	^ true
]

{ #category : #testing }
GtMethodCoder >> isForMethod: aCompiledMethod [
	^ self behavior = aCompiledMethod methodClass
		and: [ self selector = aCompiledMethod selector ]
]

{ #category : #'api - addons' }
GtMethodCoder >> isMondrianPaintMethod: aMethodNode [
	| variable |
	aMethodNode arguments size ~= 1
		ifTrue: [ ^ false ].
	('paint*With:' match: aMethodNode selector)
		ifFalse: [ ^ false ].
	variable := aMethodNode arguments first.
	aMethodNode
		nodesDo: [ :each | 
			(each isMessage and: [ each receiver = variable ])
				ifTrue: [ (GtMondrian canUnderstand: each selector)
						ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : #testing }
GtMethodCoder >> isNewMethod [
	^ self currentSourceString isEmpty
]

{ #category : #testing }
GtMethodCoder >> isOverridden [
	| sel |
	sel := self currentSelector.
	sel isNil
		ifTrue: [ ^ false ].
	self classOrMetaClass
		allSubclassesDo: [ :cls | 
			(cls includesSelector: sel)
				ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #testing }
GtMethodCoder >> isOverriding [
	| sel |
	sel := self currentSelector.
	^ sel notNil
		and: [ self classOrMetaClass superclass
				ifNil: [ false ]
				ifNotNil: [ :spr | (spr whichClassIncludesSelector: sel) notNil ] ]
]

{ #category : #'api - accessing' }
GtMethodCoder >> methodBehavior [
	<return: #GtMethodCoderBehavior>

	^ methodBehavior
]

{ #category : #'api - accessing' }
GtMethodCoder >> methodBehavior: aGtMethodCoderBehavior [
	self
		assert: [ aGtMethodCoderBehavior isKindOf: GtMethodCoderBehavior ]
		description: [ 'Behavior must be reifined as an object' ].

	methodBehavior := aGtMethodCoderBehavior
]

{ #category : #'api - refactorings' }
GtMethodCoder >> moveMethodToInstanceOrClass [
	| oldClass newClass model modelClass oldModelClass |
	oldClass := self behavior.
	newClass := oldClass isMeta
		ifTrue: [ oldClass soleInstance ]
		ifFalse: [ oldClass class ].
	self isNewMethod
		ifTrue: [ self behavior: newClass.
			^ true ].
	self canMoveMethodToInstanceOrClass
		ifFalse: [ ^ false ].
	model := RBNamespace new.
	modelClass := model classFor: newClass.
	modelClass
		compile: self currentSourceString
		classified: self protocol.
	oldModelClass := model classFor: oldClass.
	(oldModelClass directlyDefinesMethod: self currentSelector)
		ifTrue: [ oldModelClass removeMethod: self currentSelector ].
	self behavior: newClass.
	[ model changes execute ]
		ifCurtailed: [ self behavior: oldClass ].
	^ true
]

{ #category : #'private - actions' }
GtMethodCoder >> newMethodSource [
	self
		deprecated: 'Use #currentSourceString instead.'
		transformWith: '`@receiver newMethodSource' -> '`@receiver currentSourceString'.

	^ self currentSourceString
]

{ #category : #updating }
GtMethodCoder >> newRbAST: aString [
	| ast |
	ast := self parseMethod: aString.
	ast isParseError
		ifTrue: [ ^ ast ].
	ast doSemanticAnalysis.
	^ ast
]

{ #category : #'private - refactorings' }
GtMethodCoder >> nodeDescription: aNode [
	| description |
	description := aNode formattedCode.
	description size > 40
		ifTrue: [ description := (description first: 40) , '...' ].
	^ ((description copyReplaceAll: String cr with: ' ')
		copyReplaceAll: String lf
		with: ' ') copyReplaceAll: '	' with: ' '
]

{ #category : #'private - notifying' }
GtMethodCoder >> notifyClassAdded [
	self announce: (GtCoderClassAdded new coder: self)
]

{ #category : #'private - notifying' }
GtMethodCoder >> notifyClassRemoved [
	self announce: (GtCoderClassRemoved new coder: self)
]

{ #category : #'private - notifying' }
GtMethodCoder >> notifyClassRenamed [
	self announce: (GtCoderClassRenamed new coder: self)
]

{ #category : #'private - notifying' }
GtMethodCoder >> notifyMethodAdded [
	self announce: (GtCoderMethodAdded new coder: self)
]

{ #category : #'private - notifying' }
GtMethodCoder >> notifyMethodModified [
	self announce: (GtCoderMethodModified new coder: self)
]

{ #category : #'private - notifying' }
GtMethodCoder >> notifyMethodRemoved [
	self announce: (GtCoderMethodRemoved new coder: self)
]

{ #category : #accessing }
GtMethodCoder >> object [
	^ self
		attributeNamed: #object
		ifAbsent: [ (self behavior ifNil: [ nil class ]) instanceSide ]
]

{ #category : #'event handling' }
GtMethodCoder >> onClassAdded: aClassAddedAnnouncement [
	(self methodBehavior affectedByClassAdded: aClassAddedAnnouncement)
		ifFalse: [ ^ self ].

	methodBehavior := self methodBehavior affectByClassAdded: aClassAddedAnnouncement.
	self notifyClassAdded
]

{ #category : #'event handling' }
GtMethodCoder >> onClassRemoved: aClassRemovedAnnouncement [
	(self methodBehavior affectedByClassRemoved: aClassRemovedAnnouncement)
		ifFalse: [ ^ self ].
		
	methodBehavior := self methodBehavior affectByClassRemoved: aClassRemovedAnnouncement.
	self notifyClassRemoved
]

{ #category : #'event handling' }
GtMethodCoder >> onClassRenamed: aClassRenamedAnnouncement [
	(self methodBehavior affectedByClassRenamed: aClassRenamedAnnouncement)
		ifFalse: [ ^ self ].

	methodBehavior := self methodBehavior affectByClassRenamed: aClassRenamedAnnouncement.
	self notifyClassRenamed
]

{ #category : #'event handling' }
GtMethodCoder >> onMethodAdded: aMethodAddedAnnouncement [
	(aMethodAddedAnnouncement methodAdded methodClass = self behavior
		and: [ aMethodAddedAnnouncement methodAdded selector = self selector ])
			ifFalse: [ ^ self ].

	self notifyMethodAdded
]

{ #category : #'event handling' }
GtMethodCoder >> onMethodModified: aMethodModified [
	| doesAffect |

	doesAffect := self methodBehavior
		realBehaviorDo: [ :aBehavior |
			aMethodModified classAffected = aBehavior
				and: [ aMethodModified selector = self selector ] ]
		ifAbsent: [
			self methodBehavior
				behaviorNameDo: [ :aBehaviorName |
					aMethodModified classAffected name = aBehaviorName
						and: [ aMethodModified selector = self selector ] ]
			ifAbsent: [ false ] ].
	
	doesAffect
		ifFalse: [ ^ self ].

	self isModified
		ifFalse: [ self forMethod: aMethodModified newMethod ]
		ifTrue: [ sourceCode := self sourceCode asCompiledMethodSourceCode: aMethodModified newMethod ].
	
	self notifyMethodModified
]

{ #category : #'event handling' }
GtMethodCoder >> onMethodRemoved: aMethodRemovedAnnouncement [
	(aMethodRemovedAnnouncement methodRemoved methodClass = self behavior
		and: [ aMethodRemovedAnnouncement methodRemoved selector = self selector ])
			ifFalse: [ ^ self ].

	self notifyMethodRemoved
]

{ #category : #accessing }
GtMethodCoder >> package [
	^ super package
		ifNil: [ self compiledMethod
				ifNil: [ self classOrMetaClass ifNotNil: [ :cls | cls package ] ]
				ifNotNil: [ :method | method package ] ]
]

{ #category : #accessing }
GtMethodCoder >> packageTag [
	^ super packageTag
		ifNil: [ self compiledMethod
				ifNotNil: [ :method | 
					method isExtension
						ifFalse: [ self package
								ifNotNil: [ :package | 
									| cls |
									cls := self classOrMetaClass.
									cls category asString = package name asString
										ifFalse: [ package classTagForClass: cls ] ] ] ] ]
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

{ #category : #private }
GtMethodCoder >> performMethodRefactoring: refactoring [
	[ refactoring primitiveExecute ]
		on: RBRefactoringError
		do: [ :ex | ^ false ].
	(self changedSourceForCurrentMethod: refactoring model changes)
		ifNotNil: [ :source | 
			self currentSourceString: source.
			^ true ].
	^ false
]

{ #category : #'api - actions' }
GtMethodCoder >> playAll [
	self critical: [
		self isModified
			ifTrue: [
				self save
					ifFalse: [ ^ self ] ].

		self
			evaluateSelector: self selector
			object: self object ]
]

{ #category : #'api - actions' }
GtMethodCoder >> playAllAndInspect [
	"Save and execute a method"

	^ self critical: [
		self isModified
			ifTrue: [
				self save
					ifFalse: [ ^ self ] ].

		self
			evaluateSelector: self selector
			object: self object
			thenDo: [ :anEvaluationResult | self notifyObjectSpawnFromEvaluationResult: anEvaluationResult ] ]
]

{ #category : #'api - actions examples' }
GtMethodCoder >> playAndInspectExample [
	
	self critical: [
		self playExample.
	
		self
			notifyObjectSpawn: self exampleResult ]
]

{ #category : #'api - actions examples' }
GtMethodCoder >> playAndInspectSlide [

	self critical: [
		self isModified
			ifTrue: [
				self save
					ifFalse: [ ^ self ] ].

		self notifyObjectSpawn: self compiledMethod gtSlide ]
]

{ #category : #'api - actions examples' }
GtMethodCoder >> playAndInspectSlideFrom: anEditorElement [

	self critical: [
		self isModified
			ifTrue: [
				self save
					ifFalse: [ ^ self ] ].

		self
			notifyObjectSpawn: self compiledMethod gtSlide returnValueOrExampleException ]
]

{ #category : #'api - actions examples' }
GtMethodCoder >> playExample [
	self isModified
		ifTrue: [
			self save
				ifFalse: [ ^ self ] ].

	self example run
]

{ #category : #'gt-extensions' }
GtMethodCoder >> previewElement [
	"Return a preview element for the Spotter"
	<return: #BlElement>

	^ (self class forClass: self behavior source: self currentSourceString)
		expanded: true;
		asElement
]

{ #category : #printing }
GtMethodCoder >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self behavior asString;
		nextPutAll: '>>#';
		nextPutAll: self selector asString;
		nextPut: $)
]

{ #category : #'api - refactorings' }
GtMethodCoder >> protectInstVar: aNode [
	| refactoring model cls |
	model := self createRefactoringModel.
	cls := model classFor: self classOrMetaClass.
	refactoring := RBProtectInstanceVariableRefactoring
		model: model
		variable: aNode name
		class: (cls whoDefinesInstanceVariable: aNode name).
	self addRefactoringChangesPreview: refactoring at: aNode stop
]

{ #category : #'api - accessing' }
GtMethodCoder >> protocol [
	<return: #String or: nil>

	^ self
		attributeNamed: #category
		ifAbsent: [
			(self behavior notNil and: [ self selector notNil ])
				ifTrue: [ self behavior whichCategoryIncludesSelector: self selector ] ]
]

{ #category : #'api - accessing' }
GtMethodCoder >> protocol: aSymbol [
	^ self attributeNamed: #category put: aSymbol
]

{ #category : #'private - refactorings' }
GtMethodCoder >> rbSelectedNodeFrom: anEditorElement [
	| ast position node selections editor |
	ast := self rbAST.
	ast ifNil: [ ^ nil ].
	editor := anEditorElement editor.
	selections := editor selection allSelections.
	selections size = 1
		ifTrue: [ ^ ast bestNodeFor: selections first interval ]
		ifFalse: [ editor cursors cursorsCount = 1
				ifFalse: [ ^ nil ].
			position := editor cursors first position.
			ast
				nodesDo: [ :each | 
					(position between: each start and: each stop)
						ifTrue: [ node := each ] ].
			^ node ]
]

{ #category : #'private - refactorings' }
GtMethodCoder >> rbSelectedNodesFrom: anEditorElement [
	| node selections |
	selections := anEditorElement editor selection allSelections.
	selections size = 1
		ifFalse: [ ^ nil ].
	node := self rbSelectedNodeFrom: anEditorElement.
	node isNil
		ifTrue: [ ^ nil ].
	node isSequence
		ifTrue: [ | startIndex endIndex interval |
			interval := selections first interval.
			startIndex := ((node statements size to: 1 by: -1)
				detect: [ :i | (node statements at: i) stop < interval first ]
				ifNone: [ 0 ]) + 1.
			endIndex := ((1 to: node statements size)
				detect: [ :i | (node statements at: i) start > interval last ]
				ifNone: [ node statements size + 1 ]) - 1.
			startIndex <= endIndex
				ifTrue: [ ^ node statements copyFrom: startIndex to: endIndex ] ].
	^ {node}
]

{ #category : #'api - actions' }
GtMethodCoder >> remove [
	self coders
		ifNotNil: [ :theCoders | theCoders removeCoder: self ].

	self announcer
		suppress: GtCoderMethodRemoved
		during: [ self methodBehavior realBehaviorDo: [ :aBehavior | aBehavior removeSelector: selector ] ].
	
	self reset.
	
	self notifyMethodRemoved
]

{ #category : #'private - refactorings' }
GtMethodCoder >> removeHighlight [
	self sourceText
		clearAttributes: [ :attr | attr == self class nodeHighlight ]
]

{ #category : #'api - refactorings' }
GtMethodCoder >> removeParameter: aNode [
	| refactoring model cls |
	model := self createRefactoringModel.
	cls := (model classFor: self classOrMetaClass) instanceSide.
	refactoring := RBRemoveParameterRefactoring
		model: model
		removeParameter: aNode name
		in: cls
		selector: self currentSelector.
	self addRefactoringChangesPreview: refactoring at: aNode stop
]

{ #category : #'api - refactorings' }
GtMethodCoder >> renameIn: editorElement [
	| node |
	node := self rbNodeAtCursor: editorElement.
	node isNil
		ifTrue: [ ^ self ].
	(node isMessage or: [ node isMethod ])
		ifTrue: [ ^ self renameMethod: editorElement ].
	node isVariable
		ifTrue: [ node gtIsLocal
				ifTrue: [ ^ self renameLocalVariableIn: editorElement ].
			(self classOrMetaClass allInstVarNames includes: node name)
				ifTrue: [ ^ self renameInstanceVariableIn: editorElement ].
			(self classOrMetaClass classVariables
				anySatisfy: [ :assoc | assoc key asString = node name ])
				ifTrue: [ ^ self renameClassVariableIn: editorElement ].
			Smalltalk globals
				at: node name asSymbol
				ifPresent: [ :cls | 
					(cls isKindOf: Class)
						ifTrue: [ ^ self renameClassIn: editorElement ] ] ]
]

{ #category : #'api - refactorings' }
GtMethodCoder >> renameLocalVariableIn: editorElement [
	GtRenameAction pharoRenameLocalsOn: editorElement
]

{ #category : #'api - refactorings' }
GtMethodCoder >> renameProtocol: aString [
	| change |
	self protocol: aString asSymbol.
	selector notNil
		ifTrue: [ change := RBMethodProtocolChange
				selector: selector
				in: self behavior
				classified: self protocol.
			change execute ]
]

{ #category : #initialize }
GtMethodCoder >> reset [
	super reset.
	methodBehavior := GtMethodCoderUnspecifiedBehavior new.
	selector := nil.
	self protocol: nil
]

{ #category : #'private - refactorings' }
GtMethodCoder >> safeTemporaryName [
	| name index found ast |
	name := '_'.
	index := 0.
	ast := self rbAST.
	[ found := false.
	ast
		nodesDo: [ :each | 
			(each defines: name)
				ifTrue: [ found := true ] ].
	found
		or: [ (self classOrMetaClass allInstVarNames includes: name)
				or: [ self classOrMetaClass allClassVarNames includes: name asSymbol ] ] ]
		whileTrue: [ name := 't' , index printString.
			index := index + 1 ].
	^ name
]

{ #category : #'api - actions' }
GtMethodCoder >> save [
	"Try to save the current method validating syntax and return `true` if save was succesful, false otherwise"
	<return: #Boolean>

	self validateSyntax
		ifFalse: [ ^ false ].

	self compile
		ifFalse: [ ^ false ].

	^ true
]

{ #category : #accessing }
GtMethodCoder >> selector [
	<return: #Symbol>

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

{ #category : #'api - addons' }
GtMethodCoder >> slideAstFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(self compiledMethod notNil
		and: [ anAST notNil
				and: [ 
					anAST methodNode
						ifNotNil: [ :node | 
							node pragmas
								anySatisfy: [ :each | each isParseError not and: [ each selector = #gtSlide ] ] ]
						ifNil: [ false ] ] ])
		ifFalse: [ ^ self ].
	(anAST methodNode numArgs = 1) ifFalse: [ ^ self ].
	coderAddOns
		addContextAction: 'Play and Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anEvent | self playAndInspectSlide ].
]

{ #category : #'api - accessing' }
GtMethodCoder >> sourceCode: aGtCoderSourceCode [
	self clearExample.
	super sourceCode: aGtCoderSourceCode.
]

{ #category : #'api - accessing' }
GtMethodCoder >> sourceCodeSynchronously: aGtCoderSourceCode [
	self clearExample.
	super sourceCodeSynchronously: aGtCoderSourceCode.
]

{ #category : #'private - subscriptions' }
GtMethodCoder >> subscribeToSystem [
	self unsubscribeFromSystem.

	SystemAnnouncer uniqueInstance weak
		when: ClassAdded send: #onClassAdded: to: self;
		when: ClassRenamed send: #onClassRenamed: to: self;
		when: ClassRemoved send: #onClassRemoved: to: self;
		when: MethodAdded send: #onMethodAdded: to: self;
		when: MethodRemoved send: #onMethodRemoved: to: self;
		when: MethodModified send: #onMethodModified: to: self
]

{ #category : #'api - addons' }
GtMethodCoder >> unaryMessageAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 20>
	| isUnaryInstanceSideMethod isUnaryClassSideMethod |
	isUnaryInstanceSideMethod := (self hasObjectAttribute
		and: [ anAST notNil
			and: [ anAST methodNode
				ifNotNil: [ :node | node arguments isEmpty ]
				ifNil: [ false ] ] ]).
	isUnaryClassSideMethod := (anAST notNil
		and: [ anAST methodNode
			ifNotNil: [ :node | node arguments isEmpty and: [ 
				node methodClass isClassSide ] ]
			ifNil: [ false ] ] ).
	(isUnaryInstanceSideMethod or: [ isUnaryClassSideMethod ])		
		ifFalse: [ coderAddOns removeContextAction: 'Play' translated.
			coderAddOns removeContextAction: 'Play and Inspect' translated.
			coderAddOns removeContextAction: 'Debug' translated.
			^ self ].
	coderAddOns
		addContextAction: 'Play' translated
		icon: BrGlamorousVectorIcons play
		action: [ :aCoderUIModel :anEvent | self playAll ].
	coderAddOns
		addContextAction: 'Play and Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anEvent | self playAllAndInspect ].
	coderAddOns
		addContextAction: 'Debug' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :aCoderUIModel :anEvent | self debug ]
]

{ #category : #'private - subscriptions' }
GtMethodCoder >> unsubscribeFromExample [
	self
		attributeNamed: #example
		ifPresent: [ :anOldExampleWithResult | anOldExampleWithResult announcer unsubscribe: self ]
		ifAbsent: [ "do nothing" ].
]
