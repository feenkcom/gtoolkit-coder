"
! Method Coder
I extend a ${class:GtSourceCoder}$ with the knowledge of how to edit a method. In particular, I am aware of different types of methods and provide a wider variety of refactorings and actions. 
!! Refactorings

!!! What is the difference between ${method:GtMethodCoder>>#selector}$ and ${method:GtMethodCoder>>#currentSelector}$
"
Class {
	#name : #GtPharoMethodCoder,
	#superclass : #GtPharoSourceCoder,
	#instVars : [
		'methodBehavior',
		'selector'
	],
	#classVars : [
		'NodeHighlight'
	],
	#category : #'GToolkit-Coder-Pharo-Coders'
}

{ #category : #'instance creation' }
GtPharoMethodCoder class >> forClass: aBehavior source: aString [
	^ self new
		forClass: aBehavior source: aString;
		yourself
]

{ #category : #'instance creation' }
GtPharoMethodCoder class >> forExample: anExample [
	^ self new
		forExample: anExample;
		yourself
]

{ #category : #'instance creation' }
GtPharoMethodCoder class >> forMethod: aCompiledMethod [
	^ self new
		forMethod: aCompiledMethod;
		yourself
]

{ #category : #'instance creation' }
GtPharoMethodCoder class >> forNewMethod: aBehavior [
	^ self forClass: aBehavior source: ''
]

{ #category : #'instance creation' }
GtPharoMethodCoder class >> forObject: anObject andSelector: aSymbol [
	^ (self forMethod: anObject class >> aSymbol)
		object: anObject;
		yourself
]

{ #category : #accessing }
GtPharoMethodCoder class >> nodeHighlight [
	^ NodeHighlight
		ifNil: [ NodeHighlight := BlTextHighlightAttribute new
				paint: BrGlamorousColors textHighlightColor ]
]

{ #category : #'api - refactorings' }
GtPharoMethodCoder >> abstractClassVar: aNode [
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
GtPharoMethodCoder >> abstractInstVar: aNode [
	| refactoring model cls |
	model := self createRefactoringModel.
	cls := model classFor: self behavior.
	refactoring := RBAbstractInstanceVariableRefactoring
		model: model
		variable: aNode variableName
		class: (cls whoDefinesInstanceVariable: aNode variableName).
	self addRefactoringChangesPreview: refactoring at: aNode stopPosition
]

{ #category : #'api - refactorings' }
GtPharoMethodCoder >> addClassVariable: aString [
	| refactoring |
	refactoring := RBAddClassVariableRefactoring
		variable: aString
		class: self behavior instanceSide.
	refactoring execute.

	"Need to reset AST for undeclared variables"
	self resetASTCache.

	"and restyle the text"
	self requestStyleSourceText
]

{ #category : #'api - refactorings' }
GtPharoMethodCoder >> addInstanceVariable: aString [
	| refactoring |
	refactoring := RBAddInstanceVariableRefactoring
		variable: aString
		class: self behavior.
	refactoring execute.
	self resetASTCache.	"Need to reset AST for undeclared variables"
	self requestStyleSourceText
]

{ #category : #'api - accessing' }
GtPharoMethodCoder >> behavior [
	<return: #GtMethodCoderBehavior>

	self methodBehavior isClass
		ifTrue: [ ^ self methodBehavior ].

	self methodBehavior realBehaviorDo: [ :aBehavior | ^ aBehavior ].
	^ UndefinedObject
]

{ #category : #'api - accessing' }
GtPharoMethodCoder >> behavior: aBehavior [
	self methodBehavior: (GtMethodCoderExplicitBehavior new behavior: aBehavior)
]

{ #category : #testing }
GtPharoMethodCoder >> canCompileMethodIn: newClass [
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
GtPharoMethodCoder >> canExecuteExample [
	<return: #Boolean>

	^ self example
		ifNil: [ false ]
		ifNotNil: [ :anExample | anExample canBeExecuted ]
]

{ #category : #testing }
GtPharoMethodCoder >> canMoveMethodToInstanceOrClass [
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
GtPharoMethodCoder >> category [
	self
		deprecated: 'Use #protocol instead.'
		transformWith: '`@receiver category' -> '`@receiver protocol'.

	^ self protocol
]

{ #category : #'api - accessing' }
GtPharoMethodCoder >> category: aSymbol [
	self
		deprecated: 'Use #protocol: instead.'
		transformWith: '`@receiver category: `@arg' -> '`@receiver protocol: `@arg'.

	self protocol: aSymbol
]

{ #category : #'private - actions' }
GtPharoMethodCoder >> changeManager [
	^ RBRefactoryChangeManager instance
]

{ #category : #private }
GtPharoMethodCoder >> changedSourceForCurrentMethod: aRefactoryChange [
	aRefactoryChange changes
		reverseDo: [ :each | 
			((each isKindOf: RBAddMethodChange)
				and: [ each selector = self currentSelector
						and: [ self behavior = each changeClass ] ])
				ifTrue: [ ^ each source ] ].
	^ nil
]

{ #category : #accessing }
GtPharoMethodCoder >> classOrMetaClass: aBehavior [
	self
		deprecated: 'Use #behavior: instead.'
		transformWith: '`@receiver classOrMetaClass: `@arg' -> '`@receiver behavior: `@arg'.

	self behavior: aBehavior
]

{ #category : #'private - actions' }
GtPharoMethodCoder >> clearExample [
	self unsubscribeFromExample.
	self removeAttributeNamed: #example.
]

{ #category : #private }
GtPharoMethodCoder >> compilationRequester [
	^ GtSourceCoderCompilationRequester new coder: self
]

{ #category : #'api - actions' }
GtPharoMethodCoder >> compile [
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
GtPharoMethodCoder >> compiledMethod [
	<return: #CompiledMethod or: nil>
	
	^ self existsInTheSystem
		ifTrue: [ self behavior >> self selector ]
		ifFalse: [ nil ]
]

{ #category : #'api - ast' }
GtPharoMethodCoder >> computeAst: theSourceString [
	^ GtPharoParser
		parseWithErrors: theSourceString
		startingAt: self parserStartingState
]

{ #category : #'api - refactorings' }
GtPharoMethodCoder >> createAccessorsFor: aNode instanceVariable: aBoolean [
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
GtPharoMethodCoder >> createCompileMethodChange [
	<return: #RBAddMethodChange or: nil>

	^ self methodBehavior
		realBehaviorDo: [ :aBehavior | self createCompileMethodChangeIn: aBehavior ]
		ifAbsent: [ nil ]
]

{ #category : #private }
GtPharoMethodCoder >> createCompileMethodChangeIn: aBehavior [
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
GtPharoMethodCoder >> createLabel: aString description: description [
	^ aString asRopedText
		,
			((' ' , description) asRopedText
				attributes:
					{(BlFontSizeAttribute size: 12).
					(BlTextForegroundAttribute paint: Color gray)})
]

{ #category : #private }
GtPharoMethodCoder >> createRefactoringModel [
	| model |
	model := RBClassModelFactory rbNamespace
		onEnvironment: RBBrowserEnvironment new.
	(((model classFor: self behavior)
		directlyDefinesMethod: self currentSelector) not
		or:
			[ ((model classFor: self behavior) sourceCodeFor: self currentSelector)
				~= self sourceText asString ])
		ifTrue: [ (model classFor: self classOrMetaClass)
				compile: self sourceText asString
				classified: self category ].
	^ model
]

{ #category : #accessing }
GtPharoMethodCoder >> currentSelector [
	| theAst |

	selector
		ifNotNil: [ ^ selector ].

	theAst := self astAwait.
	theAst
		ifNil: [ ^ nil ].
	
	theAst isMethod
		ifFalse: [ ^ #faulty ].
			
	 ^ theAst selector
]

{ #category : #'api - actions' }
GtPharoMethodCoder >> debug [
	self isModified ifTrue: [
		self save
			ifFalse: [ ^ self ] ].

	self class
		debug: self compiledMethod
		receiver: self object
		in: self context
]

{ #category : #'api - actions examples' }
GtPharoMethodCoder >> debugExample [
	self isModified
		ifTrue: [ self save
			ifFalse: [ ^ self ] ].
	self example openingDebugger result
]

{ #category : #'private - actions' }
GtPharoMethodCoder >> evaluateSelector: aSymbol object: anObject [
	^ self
		evaluateSelector: aSymbol
		object: anObject
		thenDo: [ ]
]

{ #category : #'private - actions' }
GtPharoMethodCoder >> evaluateSelector: aSymbol object: anObject thenDo: aThenBlock [
	"Evaluate a given source code and show the print string if needed"
	| aReceiver aSourceString aResult |

	"we can not wrap everything in a critical: because if there is an exception while evaluating
	the source code the current running process will be suspended, meaning that the very next evaluation
	will indefinitely wait when trying to enter a critical section."
	self critical: [
		aReceiver := (anObject respondsTo: aSymbol)
			ifTrue: [ anObject ]
			ifFalse: [ anObject class ].
			
	aSourceString := self currentSourceString. ].

	aResult := self
		evaluateBlock: [ aReceiver perform: aSymbol ]
		onErrorDo: [ :aResultWithError |
			aResultWithError
				sourceString: aSourceString;
				sourceInterval: (1 to: aSourceString size) ].

	aResult
		sourceString: aSourceString;
		sourceInterval: (1 to: aSourceString size).

	self notifyEvaluatedWithResult: aResult.
	aThenBlock cull: aResult.

	^ aResult
]

{ #category : #'api - actions examples' }
GtPharoMethodCoder >> example [
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
GtPharoMethodCoder >> example: anExampleWithResult [
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
GtPharoMethodCoder >> exampleResult [
	<return: #GtExampleResult or: nil>
	^ self example ifNotNil: #result
]

{ #category : #testing }
GtPharoMethodCoder >> existsInTheSystem [
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
GtPharoMethodCoder >> explanationLink [
	^ self attributeNamed: #explanationLink
]

{ #category : #accessing }
GtPharoMethodCoder >> explanationLink: anExplanation [
	self explanationLink == anExplanation
		ifTrue: [ ^ self ].

	self attributeNamed: #explanationLink put: anExplanation.
	
	self requestStyleSourceText.
	self requestUpdateAddOns
]

{ #category : #'api - refactorings' }
GtPharoMethodCoder >> extractTemporaryVariable: aNode in: anEditorElement [
	| refactoring model tempName |
	model := self createRefactoringModel.
	tempName := self safeTemporaryName.
	refactoring := RBExtractToTemporaryRefactoring
		model: model
		extract: aNode sourceInterval
		to: tempName
		from: self currentSelector
		in: (model classFor: self behavior).
	(self performMethodRefactoring: refactoring)
		ifFalse: [ ^ self ].
	(self findNodeAssigning: tempName)
		ifNotNil: [ :node | 
			anEditorElement editor moveCursorTo: node stop.
			self renameLocalVariableIn: anEditorElement ]
]

{ #category : #'private - refactorings' }
GtPharoMethodCoder >> findNodeAssigning: aString [
	self rbAST
		nodesDo: [ :each | 
			(each isAssignment and: [ each variable name = aString ])
				ifTrue: [ ^ each variable ] ].
	^ nil
]

{ #category : #private }
GtPharoMethodCoder >> findSeparatorBetweenPatternAndBodyIn: aMethodNode [
	| startIndex char source |
	source := aMethodNode completeSource.
	startIndex := aMethodNode pattern stopPosition + 1.
	[ startIndex <= source size and: [ (char := source at: startIndex) isSeparator and: [ char ~= Character cr ] ] ]
		whileTrue: [ startIndex := startIndex + 1 ].
	^ startIndex
]

{ #category : #initialize }
GtPharoMethodCoder >> forClass: aBehavior source: aString [
	self behavior: aBehavior.
	self sourceCode: (GtCoderExplicitSourceCode new source: aString)
]

{ #category : #initialize }
GtPharoMethodCoder >> forExample: anExampleWithResult [
	self forMethod: anExampleWithResult method.
	self example: anExampleWithResult
]

{ #category : #initialize }
GtPharoMethodCoder >> forMethod: aCompiledMethod [
	self methodBehavior:(GtMethodCoderExplicitBehavior new behavior: aCompiledMethod methodClass).
	self selector: aCompiledMethod selector.
	self sourceCode: (GtCoderCompiledMethodSourceCode new compiledMethod: aCompiledMethod).
	self protocol: aCompiledMethod category
]

{ #category : #'api - actions' }
GtPharoMethodCoder >> format [
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
GtPharoMethodCoder >> gtDiffViewFor: aView [
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
GtPharoMethodCoder >> handleCompilerErrorsDuring: aBlock [
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
GtPharoMethodCoder >> handleExampleArgumentsChanged: aGtExampleArgumentsChanged [
	self requestUpdateAddOns
]

{ #category : #'examples - event handling' }
GtPharoMethodCoder >> handleExampleExecuted: aGtExampleExecuted [
	self requestStyleSourceText.
	self announce: (GtCoderExampleExecuted new 
		coder: self;
		example: aGtExampleExecuted example)
]

{ #category : #'private - refactorings' }
GtPharoMethodCoder >> highlightFrom: startIndex to: endIndex [
	(self sourceText from: startIndex to: endIndex)
		attributes: { self class nodeHighlight }
]

{ #category : #'private - refactorings' }
GtPharoMethodCoder >> highlightNode: aNode [
	self highlightFrom: aNode startPosition to: aNode stopPosition
]

{ #category : #accessing }
GtPharoMethodCoder >> highlighter [
	<return: #GtSourceReferenceHighlighter>

	^ self attributeNamed: #highlighter
]

{ #category : #accessing }
GtPharoMethodCoder >> highlighter: aGtSourceReferenceHighlighter [
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

{ #category : #'api - refactorings' }
GtPharoMethodCoder >> inlineMessageSendIn: messageNode [
	| refactoring model |
	model := self createRefactoringModel.
	refactoring := RBInlineMethodRefactoring
		model: model
		inline: messageNode sourceInterval
		inMethod: self currentSelector
		forClass: (model classFor: self behavior).
	refactoring
		setOption: #inlineExpression
		toUse: [ :ref :string | true ].
	self performMethodRefactoring: refactoring
]

{ #category : #'api - refactorings' }
GtPharoMethodCoder >> inlineTemporaryVariableIn: assignmentNode [
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
GtPharoMethodCoder >> isAccessorMethodFor: aNode [
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
GtPharoMethodCoder >> isForMethod [
	^ true
]

{ #category : #testing }
GtPharoMethodCoder >> isForMethod: aCompiledMethod [
	^ self behavior = aCompiledMethod methodClass
		and: [ self selector = aCompiledMethod selector ]
]

{ #category : #'api - addons' }
GtPharoMethodCoder >> isMondrianPaintMethod: aMethodNode [
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
GtPharoMethodCoder >> isNewMethod [
	^ self currentSourceString isEmpty
]

{ #category : #testing }
GtPharoMethodCoder >> isOverridden [
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
GtPharoMethodCoder >> isOverriding [
	| sel |
	sel := self currentSelector.
	^ sel notNil
		and: [ self classOrMetaClass superclass
				ifNil: [ false ]
				ifNotNil: [ :spr | (spr whichClassIncludesSelector: sel) notNil ] ]
]

{ #category : #'api - accessing' }
GtPharoMethodCoder >> methodBehavior [
	<return: #GtMethodCoderBehavior>

	^ methodBehavior
]

{ #category : #'api - accessing' }
GtPharoMethodCoder >> methodBehavior: aGtMethodCoderBehavior [
	self
		assert: [ aGtMethodCoderBehavior isKindOf: GtMethodCoderBehavior ]
		description: [ 'Behavior must be reifined as an object' ].

	methodBehavior := aGtMethodCoderBehavior
]

{ #category : #'api - refactorings' }
GtPharoMethodCoder >> moveMethodToInstanceOrClass [
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
GtPharoMethodCoder >> newMethodSource [
	self
		deprecated: 'Use #currentSourceString instead.'
		transformWith: '`@receiver newMethodSource' -> '`@receiver currentSourceString'.

	^ self currentSourceString
]

{ #category : #updating }
GtPharoMethodCoder >> newRbAST: aString [
	| ast |
	self isModified
		ifFalse: [ self compiledMethod ifNotNil: [ :m | ^ m ast ] ].
	ast := self parseMethod: aString.
	ast isParseError
		ifTrue: [ ^ ast ].
	ast doSemanticAnalysis.
	^ ast
]

{ #category : #'private - refactorings' }
GtPharoMethodCoder >> nodeDescription: aNode [
	| description |
	description := aNode formattedCode.
	description size > 40
		ifTrue: [ description := (description first: 40) , '...' ].
	^ ((description copyReplaceAll: String cr with: ' ')
		copyReplaceAll: String lf
		with: ' ') copyReplaceAll: '	' with: ' '
]

{ #category : #'private - notifying' }
GtPharoMethodCoder >> notifyClassAdded [
	self announce: (GtCoderClassAdded new coder: self)
]

{ #category : #'private - notifying' }
GtPharoMethodCoder >> notifyClassRemoved [
	self announce: (GtCoderClassRemoved new coder: self)
]

{ #category : #'private - notifying' }
GtPharoMethodCoder >> notifyClassRenamed [
	self announce: (GtCoderClassRenamed new coder: self)
]

{ #category : #'private - notifying' }
GtPharoMethodCoder >> notifyMethodAdded [
	self announce: (GtCoderMethodAdded new coder: self)
]

{ #category : #'private - notifying' }
GtPharoMethodCoder >> notifyMethodModified [
	self announce: (GtCoderMethodModified new coder: self)
]

{ #category : #'private - notifying' }
GtPharoMethodCoder >> notifyMethodRemoved [
	self announce: (GtCoderMethodRemoved new coder: self)
]

{ #category : #accessing }
GtPharoMethodCoder >> object [
	^ self
		attributeNamed: #object
		ifAbsent: [ (self behavior ifNil: [ nil class ]) instanceSide ]
]

{ #category : #'event handling' }
GtPharoMethodCoder >> onClassAdded: aClassAddedAnnouncement [
	(self methodBehavior affectedByClassAdded: aClassAddedAnnouncement)
		ifFalse: [ ^ self ].

	methodBehavior := self methodBehavior affectByClassAdded: aClassAddedAnnouncement.
	self notifyClassAdded
]

{ #category : #'event handling' }
GtPharoMethodCoder >> onClassRemoved: aClassRemovedAnnouncement [
	(self methodBehavior affectedByClassRemoved: aClassRemovedAnnouncement)
		ifFalse: [ ^ self ].
		
	methodBehavior := self methodBehavior affectByClassRemoved: aClassRemovedAnnouncement.
	self notifyClassRemoved
]

{ #category : #'event handling' }
GtPharoMethodCoder >> onClassRenamed: aClassRenamedAnnouncement [
	(self methodBehavior affectedByClassRenamed: aClassRenamedAnnouncement)
		ifFalse: [ ^ self ].

	methodBehavior := self methodBehavior affectByClassRenamed: aClassRenamedAnnouncement.
	self notifyClassRenamed
]

{ #category : #'event handling' }
GtPharoMethodCoder >> onMethodAdded: aMethodAddedAnnouncement [

	(aMethodAddedAnnouncement methodAdded methodClass = self behavior
		and: [ aMethodAddedAnnouncement methodAdded selector = self selector ])
			ifFalse: [ ^ self ].

	self isModified
		ifFalse: [ self forMethod: aMethodAddedAnnouncement methodAdded ]
		ifTrue: [ self sourceCode: (self sourceCode asCompiledMethodSourceCode: aMethodAddedAnnouncement methodAdded) ].

	self notifyMethodAdded
]

{ #category : #'event handling' }
GtPharoMethodCoder >> onMethodModified: aMethodModified [
	| doesAffect |

	doesAffect := self methodBehavior
		realBehaviorDo: [ :aBehavior |
			aMethodModified classAffected = aBehavior
				and: [ aMethodModified oldMethod selector = self selector
					or: [ aMethodModified newMethod selector = self selector ] ] ]
		ifAbsent: [
			self methodBehavior
				behaviorNameDo: [ :aBehaviorName |
					aMethodModified classAffected name = aBehaviorName
						and: [ aMethodModified oldMethod selector = self selector
							or: [ aMethodModified newMethod selector = self selector ] ] ]
			ifAbsent: [ false ] ].

	doesAffect
		ifFalse: [ ^ self ].

	self isModified
		ifFalse: [ self forMethod: aMethodModified newMethod ]
		ifTrue: [ self sourceCode: (self sourceCode asCompiledMethodSourceCode: aMethodModified newMethod) ].

	self notifyMethodModified
]

{ #category : #'event handling' }
GtPharoMethodCoder >> onMethodRemoved: aMethodRemovedAnnouncement [

	(aMethodRemovedAnnouncement methodRemoved methodClass = self behavior
		and: [ aMethodRemovedAnnouncement methodRemoved selector = self selector ])
			ifFalse: [ ^ self ].

	self notifyMethodRemoved
]

{ #category : #accessing }
GtPharoMethodCoder >> package [
	^ super package
		ifNil: [ self compiledMethod
				ifNil: [ self behavior ifNotNil: [ :cls | cls package ] ]
				ifNotNil: [ :method | method package ] ]
]

{ #category : #accessing }
GtPharoMethodCoder >> packageTag [
	^ super packageTag
		ifNil: [ self compiledMethod
				ifNotNil: [ :method | 
					method isExtension
						ifFalse: [ self package
								ifNotNil: [ :package | 
									| cls |
									cls := self behavior.
									cls category asString = package name asString
										ifFalse: [ package classTagForClass: cls ] ] ] ] ]
]

{ #category : #private }
GtPharoMethodCoder >> parserStartingState [
	^ GtPharoParser startingStateForMethod
]

{ #category : #private }
GtPharoMethodCoder >> performMethodRefactoring: refactoring [
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
GtPharoMethodCoder >> playAll [
	self isModified
		ifTrue: [
			self save
				ifFalse: [ ^ self ] ].

	^ self
		evaluateSelector: self selector
		object: self object
]

{ #category : #'api - actions' }
GtPharoMethodCoder >> playAllAndInspect [
	"Save and execute a method"

	self isModified
		ifTrue: [
			self save
				ifFalse: [ ^ self ] ].

	^ self
		evaluateSelector: self selector
		object: self object
		thenDo: [ :anEvaluationResult | self notifyObjectSpawnFromEvaluationResult: anEvaluationResult ]
]

{ #category : #'api - actions examples' }
GtPharoMethodCoder >> playAndInspectExample [
	self playExample.
	self notifyObjectSpawn: self exampleResult returnValueOrExampleException
]

{ #category : #'api - actions examples' }
GtPharoMethodCoder >> playAndInspectSlide [

	self isModified
		ifTrue: [
			self save
				ifFalse: [ ^ self ] ].

	self notifyObjectSpawn: self compiledMethod gtSlide
]

{ #category : #'api - actions examples' }
GtPharoMethodCoder >> playAndInspectSlideFrom: anEditorElement [

	self isModified
		ifTrue: [
			self save
				ifFalse: [ ^ self ] ].

	self
		notifyObjectSpawn: self compiledMethod gtSlide returnValueOrExampleException
]

{ #category : #'api - actions examples' }
GtPharoMethodCoder >> playExample [
	self isModified
		ifTrue: [
			self save
				ifFalse: [ ^ self ] ].

	self example run
]

{ #category : #'gt-extensions' }
GtPharoMethodCoder >> previewElement [
	"Return a preview element for the Spotter"
	<return: #BlElement>

	^ (self class forClass: self behavior source: self currentSourceString)
		expanded: true;
		asElement
]

{ #category : #printing }
GtPharoMethodCoder >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self behavior asString;
		nextPutAll: '>>#';
		nextPutAll: self selector asString;
		nextPut: $)
]

{ #category : #'api - refactorings' }
GtPharoMethodCoder >> protectInstVar: aNode [
	| refactoring model cls |
	model := self createRefactoringModel.
	cls := model classFor: self behavior.
	refactoring := RBProtectInstanceVariableRefactoring
		model: model
		variable: aNode name
		class: (cls whoDefinesInstanceVariable: aNode name).
	self addRefactoringChangesPreview: refactoring at: aNode stop
]

{ #category : #'api - accessing' }
GtPharoMethodCoder >> protocol [
	<return: #String or: nil>

	^ self
		attributeNamed: #category
		ifAbsent: [
			(self behavior notNil and: [ self selector notNil ])
				ifTrue: [ self behavior whichCategoryIncludesSelector: self selector ] ]
]

{ #category : #'api - accessing' }
GtPharoMethodCoder >> protocol: aSymbol [
	^ self attributeNamed: #category put: aSymbol
]

{ #category : #'api - actions' }
GtPharoMethodCoder >> remove [
	self coders
		ifNotNil: [ :theCoders | theCoders removeCoder: self ].

	self announcer
		suppress: GtCoderMethodRemoved
		during: [ self methodBehavior realBehaviorDo: [ :aBehavior | aBehavior removeSelector: selector ] ].
	
	self reset.
	
	self notifyMethodRemoved
]

{ #category : #'private - refactorings' }
GtPharoMethodCoder >> removeHighlight [
	self sourceText
		clearAttributes: [ :attr | attr == self class nodeHighlight ]
]

{ #category : #'api - refactorings' }
GtPharoMethodCoder >> removeParameter: aNode [
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
GtPharoMethodCoder >> renameProtocol: aString [
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
GtPharoMethodCoder >> reset [
	super reset.
	methodBehavior := GtMethodCoderUnspecifiedBehavior new.
	selector := nil.
	self protocol: nil
]

{ #category : #'private - refactorings' }
GtPharoMethodCoder >> safeTemporaryName [
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
		or: [ (self behavior allInstVarNames includes: name)
				or: [ self behavior allClassVarNames includes: name asSymbol ] ] ]
		whileTrue: [ name := 't' , index printString.
			index := index + 1 ].
	^ name
]

{ #category : #'api - actions' }
GtPharoMethodCoder >> save [
	"Try to save the current method validating syntax and return `true` if save was succesful, false otherwise"
	<return: #Boolean>

	self validateSyntax
		ifFalse: [ ^ false ].

	self compile
		ifFalse: [ ^ false ].

	^ true
]

{ #category : #accessing }
GtPharoMethodCoder >> selector [
	<return: #Symbol>

	^ selector
]

{ #category : #accessing }
GtPharoMethodCoder >> selector: aSymbol [
	selector := aSymbol
]

{ #category : #private }
GtPharoMethodCoder >> skipBlankLinesIn: source at: startIndex [
	| char index |
	index := startIndex.
	[ index <= source size and: [ (char := source at: index) = Character cr or: [ char = Character lf ] ] ]
		whileTrue: [ index := index + 1 ].
	^ index
]

{ #category : #'api - addons' }
GtPharoMethodCoder >> slideAstFor: anAST into: coderAddOns [
	"<gtAstCoderAddOns: 10>"
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
GtPharoMethodCoder >> sourceCode: aGtCoderSourceCode withStrategy: anUpdateStragegy [
	self clearExample.
	super sourceCode: aGtCoderSourceCode withStrategy: anUpdateStragegy
]

{ #category : #'private - subscriptions' }
GtPharoMethodCoder >> subscribeToSystem [
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
GtPharoMethodCoder >> unaryMessageAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 20>
	| isUnaryInstanceSideMethod isUnaryClassSideMethod |
	
	self compiledMethod
		ifNil: [ ^ self ].
	
	isUnaryInstanceSideMethod := (self hasObjectAttribute
		and: [ anAST notNil
			and: [ anAST methodNode
				ifNotNil: [ :node | node variables isEmpty ]
				ifNil: [ false ] ] ]).
	isUnaryClassSideMethod := (anAST notNil
		and: [ anAST methodNode
			ifNotNil: [ :node | node variables isEmpty and: [ self compiledMethod methodClass isClassSide ] ]
			ifNil: [ false ] ] ).
	(isUnaryInstanceSideMethod or: [ isUnaryClassSideMethod ])		
		ifFalse: [ ^ self ].
	coderAddOns
		addContextAction: 'Play' translated
		icon: BrGlamorousVectorIcons play
		action: [ :aCoderUIModel :anEvent | 
			GtCoderCodeExecutor playAll
				coderUIModel: aCoderUIModel;
				event: anEvent;
				execute ].
	coderAddOns
		addContextAction: 'Play and Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anEvent | 
			GtCoderCodeExecutor playAllAndInspect
				coderUIModel: aCoderUIModel;
				event: anEvent;
				execute ].
	coderAddOns
		addContextAction: 'Debug' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :aCoderUIModel :anEvent | self debug ]
]

{ #category : #'private - subscriptions' }
GtPharoMethodCoder >> unsubscribeFromExample [
	self
		attributeNamed: #example
		ifPresent: [ :anOldExampleWithResult | anOldExampleWithResult announcer unsubscribe: self ]
		ifAbsent: [ "do nothing" ].
]
