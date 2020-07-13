"
! Method Coder
I extend a ${class:GtSourceCoder}$ with the knowledge of how to edit a method. In particular, I am aware of different types of methods and provide a wider variety of refactorings and actions.

!! Actions


!!! What is the difference between ${method:GtMethodCoder>>#selector}$ and ${method:GtMethodCoder>>#currentSelector}$
"
Class {
	#name : #GtMethodCoder,
	#superclass : #GtSourceCoder,
	#instVars : [
		'class',
		'selector',
		'methodSource',
		'subCoders',
		'isBuilt'
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

{ #category : #accessing }
GtMethodCoder class >> nodeHighlight [
	^ NodeHighlight
		ifNil: [ NodeHighlight := BlTextHighlightAttribute new
				paint: BrGlamorousColors textHighlightColor ]
]

{ #category : #'actions - refactorings' }
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

{ #category : #'actions - refactorings' }
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

{ #category : #'add ons-refactoring' }
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

{ #category : #'actions - refactorings' }
GtMethodCoder >> addClassVariable: aString [
	| refactoring |
	refactoring := RBAddClassVariableRefactoring
		variable: aString
		class: self classOrMetaClass instanceSide.
	refactoring execute.
	self resetASTCache.	"Need to reset AST for undeclared variables"
	self styleText
]

{ #category : #'add ons-refactoring' }
GtMethodCoder >> addExtractMethodTo: coderAddOns [
	| nodes |
	nodes := self rbSelectedNodes.
	nodes isNil
		ifTrue: [ ^ self ].
	coderAddOns
		addContextMenuItem: 'Extract method'
		hover: [ self highlightFrom: nodes first start to: nodes last stop ]
		leave: [ self removeHighlight ]
		action: [ :element | self extractMethod: element ]
]

{ #category : #'add ons-refactoring' }
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

{ #category : #'add ons-refactoring' }
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

{ #category : #'add ons-refactoring' }
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

{ #category : #'add ons-refactoring' }
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

{ #category : #'actions - refactorings' }
GtMethodCoder >> addInstanceVariable: aString [
	| refactoring |
	refactoring := RBAddInstanceVariableRefactoring
		variable: aString
		class: self classOrMetaClass.
	refactoring execute.
	self resetASTCache.	"Need to reset AST for undeclared variables"
	self styleText
]

{ #category : #'private - refactorings' }
GtMethodCoder >> addRefactoringChangesPreview: aRefactoring at: position [
	self removeRefactoringAttribute.
	aRefactoring isNil
		ifTrue: [ ^ self ].
	(self sourceEditor text from: position to: position)
		attributes: {(GtRefactoringChangesAttribute new refactoring: aRefactoring)}
]

{ #category : #'add ons-refactoring' }
GtMethodCoder >> addRefactoringContextMenuAddOnsTo: coderAddOns [
	<gtCoderContextMenuAddOns: 20>
	self addExtractMethodTo: coderAddOns.
	self rbSelectedNode
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

{ #category : #'add ons-refactoring' }
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

{ #category : #accessing }
GtMethodCoder >> addSubCoder: aMethodCoder [
	self subCoders addFirst: aMethodCoder
]

{ #category : #'add ons' }
GtMethodCoder >> baselineAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(anAST isNil or: [ anAST methodNode isNil ])
		ifTrue: [ coderAddOns removeStylerOfType: GtCoderExpandableMethodStyler.
			^ self ].
	(class isNil or: [ (class inheritsFrom: BaselineOf) not ])
		ifTrue: [ ^ self ].
	coderAddOns addStyler: GtCoderExpandableBaselineStyler new
]

{ #category : #elements }
GtMethodCoder >> breadcrumbNamedActions [
	^ Array
		streamContents: [ :aStream | 
			| aPackage aPackageName aClass aClassTool |
			aPackage := (self compiledMethod ifNil: [ self classOrMetaClass ])
				package.
			aPackageName := aPackage ifNil: [ '' ] ifNotNil: #name.
			aClass := self classOrMetaClass.
			aClassTool := self compiledMethod 
				ifNil: [ GtClassCoderTool observedClass: aClass instanceSide ] 
				ifNotNil: [ :aMethod | GtMethodCoderTool compiledMethod: aMethod ].
			aStream
				nextPut: aPackageName -> [ :aButton | 
					aButton phlow spawnTool: (GtPackageCoderTool package: aPackage) ];
				nextPut: aClass name -> [ :aButton | 
					aButton phlow spawnTool: aClassTool ] ]
]

{ #category : #'event handling' }
GtMethodCoder >> buildCollapsedText [
	| patternText |
	patternText := (self currentSelector ifNil: [ '' ]) asRopedText.
	patternText attributes: self defaultTextAttributes.
	patternText bold.
	^ patternText
]

{ #category : #private }
GtMethodCoder >> buildSource [
	| text |
	isBuilt := true.
	text := methodSource asRopedText.
	text attributes: self defaultTextAttributes.
	self sourceEditor text: text
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
	oldClass := self classOrMetaClass.
	newClass := oldClass isMeta
		ifTrue: [ oldClass soleInstance ]
		ifFalse: [ oldClass class ].
	(newClass includesSelector: self currentSelector)
		ifTrue: [ ^ false ].
	^ self canCompileMethodIn: newClass
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
GtMethodCoder >> classOrMetaClass [
	^ class ifNil: [ super classOrMetaClass ]
]

{ #category : #accessing }
GtMethodCoder >> classOrMetaClass: aBehavior [
	class := aBehavior
]

{ #category : #ui }
GtMethodCoder >> collapsedStyler [
	^ BlTextNullStyler new
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
		ifNil: [ RBAddMethodChange
				compile: self newMethodSource
				in: self classOrMetaClass
				for: self requester ]
		ifNotNil: [ :category | 
			RBAddMethodChange
				compile: self newMethodSource
				in: self classOrMetaClass
				classified: category
				for: self requester ].
	selector := change selector.
	(self
		handleCompilerErrorsDuring: [ self changeManager performChange: change ])
		ifFalse: [ ^ false ].
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
	<return: #CompiledMethod or: nil>
	^ self classOrMetaClass
		ifNotNil: [ :cls | 
			self selector
				ifNotNil: [ :sel | 
					(cls includesSelector: sel)
						ifTrue: [ 
							cls >> sel ] ] ]
]

{ #category : #'actions - refactorings' }
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
				~= self sourceEditor text asString ])
		ifTrue: [ (model classFor: self classOrMetaClass)
				compile: self sourceEditor text asString
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

{ #category : #'api - actions examples' }
GtMethodCoder >> debugExampleFrom: anElement [
	self isModified
		ifTrue: [ self save
			ifFalse: [ ^ self ] ].
	self example openingDebugger result
]

{ #category : #'api - actions' }
GtMethodCoder >> debugMethodFrom: anEditorElement [
	self isModified
		ifTrue: [ self save
			ifFalse: [ ^ self ] ].
	self debug: self compiledMethod receiver: self object in: self context.
]

{ #category : #'api - actions examples' }
GtMethodCoder >> debugSelectionOrExampleFrom: anEditorElement [
	^ (self selectedSourceInEditor: anEditorElement editor)
		ifEmpty: [ self debugExampleFrom: anEditorElement ]
		ifNotEmpty: [ :aSelectedSource | self debugSource: aSelectedSource from: anEditorElement ]
]

{ #category : #'api - actions' }
GtMethodCoder >> debugSelectionOrMethodFrom: anEditorElement [
	^ (self selectedSourceInEditor: anEditorElement editor)
		ifEmpty: [ self debugMethodFrom: anEditorElement ]
		ifNotEmpty: [ :aSelectedSource | self debugSource: aSelectedSource from: anEditorElement ]
]

{ #category : #actions }
GtMethodCoder >> discardChanges [
	"Discard not-accepted changes."
	self isModified ifFalse: [ ^ self ].
	self buildSource.
]

{ #category : #private }
GtMethodCoder >> ensureBuilt [
	isBuilt
		ifTrue: [ ^ self ].
	self buildSource
]

{ #category : #'private - actions' }
GtMethodCoder >> evaluateSelector: aSymbol object: anObject showPrintString: aBoolean in: anEditorElement [
	^ self 
		evaluateBlock: [ anObject perform: aSymbol ] 
		showPrintString: aBoolean
		in: anEditorElement
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
	| method |
	self
		attributeNamed: #example
		ifPresent:
			[ :anOldExampleWithResult | anOldExampleWithResult announcer unsubscribe: self ]
		ifAbsent: [ "do nothing" ].
	self
		attributeNamed: #example
		put: anExampleWithResult asExampleWithResult.
	method := anExampleWithResult method.
	(method selector = self selector
		and: [ method methodClass = self classOrMetaClass
				and: [ method sourceCode = methodSource ] ])
		ifFalse: [ self forMethod: method ].
	self example announcer
		when: GtExampleExecuted send: #handleExampleExecuted: to: self;
		when: GtExampleArgumentsChanged
			send: #handleExampleArgumentsChanged:
			to: self
]

{ #category : #'add ons' }
GtMethodCoder >> exampleAstFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(self compiledMethod notNil
		and: [ anAST notNil
				and: [ anAST methodNode
						ifNotNil: [ :node | 
							node pragmas
								anySatisfy: [ :each | each isParseError not and: [ each selector = #gtExample ] ] ]
						ifNil: [ false ] ] ])
		ifFalse: [ coderAddOns removeStylerOfType: GtCoderExampleStatusStyler.
			^ self ].
	coderAddOns
		addStyler:
			(GtCoderExampleStatusStyler new
				coder: self;
				classOrMetaClass: self classOrMetaClass).
	(self canExecuteExample or: [ anAST methodNode numArgs isZero ])
		ifFalse: [ ^ self ].
	coderAddOns
		addContextAction: 'Play' translated
		icon: BrGlamorousVectorIcons play
		action: [ :anEditorElement | self playExampleFrom: anEditorElement ].
	coderAddOns
		addContextAction: 'Play and Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :anEditorElement | self playAndInspectExampleFrom: anEditorElement ].
	coderAddOns
		addContextAction: 'Debug' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :anEditorElement | self debugSelectionOrExampleFrom: anEditorElement ]
]

{ #category : #'api - actions examples' }
GtMethodCoder >> exampleResult [
	<return: #GtExampleResult>
	^ self example result
]

{ #category : #accessing }
GtMethodCoder >> explanationFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	coderAddOns removeStylerOfType: GtSourceExplanationLinkStyler.
	self explanationLink notNil
		ifTrue: [ coderAddOns addStyler: self explanationLink ].
]

{ #category : #accessing }
GtMethodCoder >> explanationLink [
	^ self attributeNamed: #explanationLink
]

{ #category : #setter }
GtMethodCoder >> explanationLink: anExplanation [
	self explanationLink == anExplanation ifTrue: [ ^ self ].
	self attributeNamed: #explanationLink put: anExplanation.
	isBuilt ifFalse: [ ^ self ].
	self updateAddOns.
	self styleText
]

{ #category : #'actions - refactorings' }
GtMethodCoder >> extractMethod: editorElement [
	(GtExtractMethodController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #'actions - refactorings' }
GtMethodCoder >> extractTemporaryVariable: aNode in: anElement [
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
			self sourceEditor moveCursorTo: node stop.
			self renameLocalVariableIn: anElement ]
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
	self source: aCompiledMethod sourceCode.

	methodSource := aCompiledMethod sourceCode
]

{ #category : #updating }
GtMethodCoder >> format [
	| ast |
	ast := [ RBParser parseMethod: self source ]
		on: SyntaxErrorNotification
		do: [ :ex | 
			^ self
				reportParseError: ex errorMessage
				at: ex location
				on: self sourceEditor ].
	self source: ast formattedCode
]

{ #category : #ui }
GtMethodCoder >> gtDiffViewFor: aView [
	<gtView>
	(methodSource = self newMethodSource) ifTrue: [ ^ aView ].
	^ aView textEditor
		title: 'Diff' translated;
		priority: 11;
		text: [ :anEditor | 
			GtEpiceaDiffStencil new
				from: methodSource;
				to: self newMethodSource;
				create ]
]

{ #category : #ui }
GtMethodCoder >> gtLiveFor: aView [
	^ aView explicit 
		title: 'Live';
		priority: 10;
		stencil: [ self expanded: true ]
]

{ #category : #ui }
GtMethodCoder >> gtViewAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 6>
	(self hasObjectAttribute
		and: [ anAST notNil
				and: [ anAST methodNode
						ifNotNil: [ :node | 
							node arguments size = 1
								and: [ node pragmas
										anySatisfy:
											[ :each | each isParseError not and: [ each selector = #gtView ] ] ] ]
						ifNil: [ false ] ] ])
		ifFalse: [ coderAddOns removeContextAction: 'gtView' translated.
			^ self ].
	coderAddOns
		addContextAction: 'gtView' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :anEditorElement | self runGtViewFrom: anEditorElement ]
]

{ #category : #private }
GtMethodCoder >> handleCompilerErrorsDuring: aBlock [
	^ [ aBlock value.
	true ]
		on: OCUndeclaredVariableWarning
		do: [ :ex | 
			self
				reportParseError: 'Undeclared' translated
				at: ex location
				on: self sourceEditor.
			ex return: false ]
]

{ #category : #'examples - event handling' }
GtMethodCoder >> handleExampleArgumentsChanged: aGtExampleArgumentsChanged [
	self updateAddOns
]

{ #category : #'examples - event handling' }
GtMethodCoder >> handleExampleExecuted: aGtExampleExecuted [
	self styleSourceText
]

{ #category : #'private - refactorings' }
GtMethodCoder >> highlightFrom: startIndex to: endIndex [
	(self sourceEditor text from: startIndex to: endIndex)
		attributes: { self class nodeHighlight }
]

{ #category : #'private - refactorings' }
GtMethodCoder >> highlightNode: aNode [
	self highlightFrom: aNode start to: aNode stop
]

{ #category : #accessing }
GtMethodCoder >> highlighter [
	^ self attributeNamed: #highlighter
]

{ #category : #accessing }
GtMethodCoder >> highlighter: aHighlighter [
	self highlighter == aHighlighter ifTrue: [ ^ self ].
	self attributeNamed: #highlighter put: aHighlighter.
	isBuilt ifFalse: [ ^ self ].
	self updateAddOns.
	self styleText
]

{ #category : #'add ons' }
GtMethodCoder >> highlighterFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	coderAddOns removeStylerOfType: GtSourceReferenceHighlighter.
	self highlighter notNil
		ifTrue: [ coderAddOns addStyler: self highlighter ]
]

{ #category : #'initialize-release' }
GtMethodCoder >> initialize [
	isBuilt := false.
	methodSource := ''.
	super initialize
]

{ #category : #'initialize-release' }
GtMethodCoder >> initializeAddOns [
	super initializeAddOns.
	"addOns addStyler: GtCoderCommentStyler new."
	addOns addStyler: (GtFixItStyler new methodCoder: self).
	addOns addMainAction: 'Save' translated icon: BrGlamorousVectorIcons accept action: [ self save ].
	addOns addMainAction: 'Remove' translated icon: BrGlamorousVectorIcons remove action: [ self remove ].
	addOns clearChanges
]

{ #category : #'initialize-release' }
GtMethodCoder >> initializeShortcuts [
	super initializeShortcuts.

	addOns
		"addCollapsedShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryM;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aMethodCoder |
				aMethodCoder browseImplementors: aShortcutEvent currentTarget ];
			options: self);

		addCollapsedShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryN;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aMethodCoder |
				aMethodCoder browseReferences: aShortcutEvent currentTarget ];
			options: self);
		addCollapsedShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryB;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aMethodCoder |
				aMethodCoder browseClass: aShortcutEvent currentTarget ];
			options: self);"
		
		
		
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryD;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aMethodCoder |
				aMethodCoder playSelectionOrMethodFrom: aShortcutEvent currentTarget ];
			options: self);
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryG;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aMethodCoder |
				aMethodCoder playAndInspectSelectionOrMethodFrom: aShortcutEvent currentTarget ];
			options: self);
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryR;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aMethodCoder |
				aMethodCoder renameIn: aShortcutEvent currentTarget ];
			options: self);
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryE;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aMethodCoder |
				aMethodCoder extractMethod: aShortcutEvent currentTarget ];
			options: self);
		addShortcut: (BrTextEditorShortcut new
			combination: BlKeyCombination primaryS;
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aMethodCoder |
				aMethodCoder save ];
			options: self);
		addShortcut: (BrTextEditorShortcut new
			combination: (BlKeyCombination primaryShiftF);
			action: [ :aShortcutEvent :aShortcut :aTextEditor :aMethodCoder |
				aMethodCoder format ];
			options: self)
]

{ #category : #'actions - refactorings' }
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

{ #category : #'actions - refactorings' }
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
GtMethodCoder >> isBuilt [
	^ isBuilt
]

{ #category : #testing }
GtMethodCoder >> isForMethod: aCompiledMethod [
	^ self classOrMetaClass = aCompiledMethod methodClass and: [ self selector = aCompiledMethod selector ]
]

{ #category : #testing }
GtMethodCoder >> isModified [
	^ isBuilt and: [ methodSource ~= self newMethodSource ]
]

{ #category : #'add ons' }
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
	^ methodSource isEmpty
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

{ #category : #'event handling' }
GtMethodCoder >> methodChanged: aMethodModified [
	| aCompiledMethod |
	aCompiledMethod := self compiledMethod.
	(aCompiledMethod notNil and: [ 
		aMethodModified classAffected = aCompiledMethod methodClass
			and: [ aMethodModified selector = aCompiledMethod selector ]])
				ifFalse: [ ^ self ].
	self updateMethod: aMethodModified newMethod
]

{ #category : #'add ons' }
GtMethodCoder >> methodExpanderFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 10>
	(anAST isNil or: [ anAST methodNode isNil ])
		ifTrue: [ coderAddOns removeStylerOfType: GtCoderExpandableMethodStyler.
			^ self ].
	coderAddOns addStyler: GtCoderExpandableMethodStyler new
]

{ #category : #'add ons' }
GtMethodCoder >> modifiedMessageAstFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 1>
	self isModified
		ifTrue: [ coderAddOns
				addMainAction: 'Discard Changes' translated
				icon: BrGlamorousVectorIcons cancel
				action: [ :button | self discardChanges ] ]
		ifFalse: [ coderAddOns removeMainAction: 'Discard Changes' translated ]
]

{ #category : #'add ons' }
GtMethodCoder >> mondrianPaintAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 7>
	(self hasObjectAttribute
		and: [ anAST notNil
				and: [ anAST methodNode
						ifNotNil: [ :node | self isMondrianPaintMethod: node ]
						ifNil: [ false ] ] ])
		ifFalse: [ coderAddOns removeContextAction: 'Mondrian' translated.
			^ self ].
	coderAddOns
		addContextAction: 'Mondrian' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :anEditorElement | self runMondrianPaintFrom: anEditorElement ]
]

{ #category : #'actions - refactorings' }
GtMethodCoder >> moveMethodToInstanceOrClass [
	| oldClass newClass model modelClass oldModelClass |
	oldClass := self classOrMetaClass.
	newClass := oldClass isMeta
		ifTrue: [ oldClass soleInstance ]
		ifFalse: [ oldClass class ].
	self isNewMethod
		ifTrue: [ self classOrMetaClass: newClass.
			^ true ].
	self canMoveMethodToInstanceOrClass
		ifFalse: [ ^ false ].
	model := RBNamespace new.
	modelClass := model classFor: newClass.
	modelClass compile: self source classified: self category.
	oldModelClass := model classFor: oldClass.
	(oldModelClass directlyDefinesMethod: self currentSelector)
		ifTrue: [ oldModelClass removeMethod: self currentSelector ].
	self classOrMetaClass: newClass.
	[ model changes execute ]
		ifCurtailed: [ self classOrMetaClass: oldClass ].
	^ true
]

{ #category : #actions }
GtMethodCoder >> newMethodSource [
	^ self newSourceText asString
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

{ #category : #accessing }
GtMethodCoder >> object [
	^ self attributeNamed: #object ifAbsent: [ class ]
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
			self source: source.
			^ true ].
	^ false
]

{ #category : #'api - actions examples' }
GtMethodCoder >> playAndInspectExampleFrom: anEditorElement [
	self runExampleFrom: anEditorElement.
	anEditorElement phlow spawnObject: self exampleResult returnValueOrExampleException.
]

{ #category : #'api - actions' }
GtMethodCoder >> playAndInspectFrom: anEditorElement [
	"Save and execute a method"
	| anObject |

	self isModified
		ifTrue: [ self save
				ifFalse: [ ^ self ] ].

	anObject := self
		evaluateSelector: self selector
		object: self object
		showPrintString: false
		in: anEditorElement.

	anEditorElement phlow spawnObject: anObject
]

{ #category : #'api - actions' }
GtMethodCoder >> playAndInspectSelectionOrMethodFrom: anEditorElement [
	"If there is no selection, it saves and executes a method"
	
	anEditorElement editor hasSelection 
		ifTrue: [ self doItAndGoSelectionFrom: anEditorElement ]
		ifFalse: [ self playAndInspectFrom: anEditorElement ]
]

{ #category : #'api - actions examples' }
GtMethodCoder >> playExampleFrom: anEditorElement [
	self runExampleFrom: anEditorElement
]

{ #category : #'api - actions' }
GtMethodCoder >> playFrom: anEditorElement [
	self isModified
		ifTrue: [ self save
				ifFalse: [ ^ self ] ].
	
	self
		evaluateSelector: self selector
		object: self object
		showPrintString: false
		in: anEditorElement
]

{ #category : #'api - actions' }
GtMethodCoder >> playSelectionOrMethodFrom: anEditorElement [
	"If there is no selection, it saves and executes a method"

	anEditorElement editor hasSelection 
		ifTrue: [ self doItSelectionFrom: anEditorElement ]
		ifFalse: [ self playFrom: anEditorElement ]
]

{ #category : #elements }
GtMethodCoder >> previewElement [
	^ (self class forClass: class source: methodSource)
		expanded: true;
		asElement
]

{ #category : #printing }
GtMethodCoder >> printOn: aStream [
	super printOn: aStream.
	aStream 
		nextPut: $(;
		nextPutAll: self classOrMetaClass asString; 
		nextPutAll: '>>#';
		nextPutAll: self selector asString;  
		nextPut: $)
]

{ #category : #'actions - refactorings' }
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

{ #category : #private }
GtMethodCoder >> rbNodeAtCursor: editorElement [
	| editor ast position node |
	editor := editorElement editor.
	editor cursor cursorsCount = 1
		ifFalse: [ ^ nil ].
	ast := self rbAST.
	ast isNil
		ifTrue: [ ^ nil ].
	position := editor cursor first position.
	ast
		nodesDo: [ :each | 
			(position between: each start and: each stop)
				ifTrue: [ node := each ] ].
	^ node
]

{ #category : #'private - refactorings' }
GtMethodCoder >> rbSelectedNode [
	| ast position node selections editor |
	ast := self rbAST.
	ast isNil
		ifTrue: [ ^ nil ].
	editor := self sourceEditor.
	selections := editor selection allSelections.
	selections size = 1
		ifTrue: [ ^ ast bestNodeFor: selections first interval ]
		ifFalse: [ editor cursor cursorsCount = 1
				ifFalse: [ ^ nil ].
			position := editor cursor first position.
			ast
				nodesDo: [ :each | 
					(position between: each start and: each stop)
						ifTrue: [ node := each ] ].
			^ node ]
]

{ #category : #'private - refactorings' }
GtMethodCoder >> rbSelectedNodes [
	| node selections |
	selections := self sourceEditor selection allSelections.
	selections size = 1
		ifFalse: [ ^ nil ].
	node := self rbSelectedNode.
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

{ #category : #actions }
GtMethodCoder >> remove [
	^ class removeSelector: selector
]

{ #category : #'private - refactorings' }
GtMethodCoder >> removeHighlight [
	self sourceEditor text
		clearAttributes: [ :attr | attr == self class nodeHighlight ]
]

{ #category : #'actions - refactorings' }
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

{ #category : #'private - refactorings' }
GtMethodCoder >> removeRefactoringAttribute [
	self sourceEditor text
		clearAttributes: [ :each | each class = GtRefactoringChangesAttribute ]
]

{ #category : #accessing }
GtMethodCoder >> removeSubCoder: aMethodCoder [
	self subCoders remove: aMethodCoder ifAbsent: [  ]
]

{ #category : #'actions - refactorings' }
GtMethodCoder >> renameClassIn: editorElement [
	(GtRenameClassController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #'actions - refactorings' }
GtMethodCoder >> renameClassVariableIn: editorElement [
	(GtRenameClassVariableController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #'actions - refactorings' }
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

{ #category : #'actions - refactorings' }
GtMethodCoder >> renameInstanceVariableIn: editorElement [
	(GtRenameInstanceVariableController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #'actions - refactorings' }
GtMethodCoder >> renameLocalVariableIn: editorElement [
	GtRenameAction pharoRenameLocalsOn: editorElement
]

{ #category : #'actions - refactorings' }
GtMethodCoder >> renameMethod: editorElement [
	(GtRenameMethodController new
		coder: self;
		sourceElement: editorElement) execute
]

{ #category : #'actions - refactorings' }
GtMethodCoder >> renameProtocol: aString [
	| change |
	self category: aString asSymbol.
	selector notNil
		ifTrue: [ change := RBMethodProtocolChange
				selector: selector
				in: self classOrMetaClass
				classified: self category.
			change execute ]
]

{ #category : #'api - actions examples' }
GtMethodCoder >> runExampleFrom: anEditorElement [
	self isModified
		ifTrue: [
			self save ifFalse: [ ^ self ] ].

	self example run.

	self styleSourceTextInEditor: anEditorElement editor
]

{ #category : #actions }
GtMethodCoder >> runGtViewFrom: anElement [
	| view |
	self isModified
		ifTrue: [ self save
				ifFalse: [ ^ self ] ].
	view := self object perform: self selector with: GtPhlowEmptyView new.
	anElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: view;
				sourceElement: anElement)
]

{ #category : #actions }
GtMethodCoder >> runMondrianPaintFrom: anElement [
	| mondrian |
	self isModified
		ifTrue: [ self save
				ifFalse: [ ^ self ] ].
	mondrian := GtMondrian new.
	self object perform: self selector with: mondrian.
	anElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: mondrian;
				sourceElement: anElement)
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

{ #category : #actions }
GtMethodCoder >> save [
	^ self validateSyntax
		and: [ self compile
				and: [ self buildSource.
					true ] ]
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
GtMethodCoder >> selectorForCollapsed [
	^ self currentSelector
]

{ #category : #private }
GtMethodCoder >> skipBlankLinesIn: source at: startIndex [
	| char index |
	index := startIndex.
	[ index <= source size and: [ (char := source at: index) = Character cr or: [ char = Character lf ] ] ]
		whileTrue: [ index := index + 1 ].
	^ index
]

{ #category : #elements }
GtMethodCoder >> stylerView: anElement [
	super stylerView: anElement
]

{ #category : #accessing }
GtMethodCoder >> subCoders [
	^ subCoders ifNil: [ subCoders := OrderedCollection new ]
]

{ #category : #subscriptions }
GtMethodCoder >> subscribeToSystem [
	SystemAnnouncer uniqueInstance weak
		when: MethodModified send: #methodChanged: to: self
]

{ #category : #'add ons' }
GtMethodCoder >> unaryMessageAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 20>
	(self hasObjectAttribute
		and: [ anAST notNil
				and: [ anAST methodNode
						ifNotNil: [ :node | node arguments isEmpty ]
						ifNil: [ false ] ] ])
		ifFalse: [ coderAddOns removeContextAction: 'Play' translated.
			coderAddOns removeContextAction: 'Play and Inspect' translated.
			coderAddOns removeContextAction: 'Debug' translated.
			^ self ].
	coderAddOns
		addContextAction: 'Play' translated
		icon: BrGlamorousVectorIcons play
		action: [ :anEditorElement | self playSelectionOrMethodFrom: anEditorElement ].
	coderAddOns
		addContextAction: 'Play and Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :anEditorElement | self playAndInspectSelectionOrMethodFrom: anEditorElement ].
	coderAddOns
		addContextAction: 'Debug' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :anEditorElement | self debugSelectionOrMethodFrom: anEditorElement ]
]

{ #category : #updating }
GtMethodCoder >> updateMethod: aCompiledMethod [
	self forMethod: aCompiledMethod.
	self announce: (GtCoderMethodChanged new coder: self)
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
