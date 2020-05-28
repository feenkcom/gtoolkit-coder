Class {
	#name : #GtExtractMethodController,
	#superclass : #Object,
	#instVars : [
		'coder',
		'sourceElement',
		'extractionInterval',
		'methodArguments',
		'methodSelector',
		'isExisting',
		'extractedSelectorKeywords',
		'renameAction',
		'renameIndex',
		'originalSource'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #private }
GtExtractMethodController >> addRefactoringPreview [
	| message refactoring |
	message := self findExtractedSend.
	refactoring := self refactoring.
	self setPreviewOptionsOn: refactoring.
	coder
		addRefactoringChangesPreview: refactoring
		at: message stopPosition
]

{ #category : #private }
GtExtractMethodController >> addReorderParametersAttributes [
	| message text |
	message := self findExtractedSend.
	message isNil
		ifTrue: [ ^ self ].
	text := coder sourceEditor text.
	(message isBinary
		ifTrue: [ {message value} ]
		ifFalse: [ message values ])
		keysAndValuesDo: [ :i :each | 
			i > 1
				ifTrue: [ (text from: each startPosition - 1 to: each startPosition - 1)
						attributes:
							{(GtReorderParametersAttribute
								action: [ self swapParameterWithNext: i - 1 ]
								icon: BrGlamorousIcons left)} ].
			i < message values size
				ifTrue: [ (text from: each stopPosition to: each stopPosition)
						attributes:
							{(GtReorderParametersAttribute
								action: [ self swapParameterWithNext: i ]
								icon: BrGlamorousIcons right)} ] ].
	coder sourceEditor updater all update
]

{ #category : #executing }
GtExtractMethodController >> cancelRefactoring [
	self cancelRenaming.
	coder sourceEditor text: originalSource
]

{ #category : #executing }
GtExtractMethodController >> cancelRenaming [
	self isRenaming
		ifFalse: [ ^ self ].
	renameAction cancel
]

{ #category : #accessing }
GtExtractMethodController >> coder [
	^ coder
]

{ #category : #accessing }
GtExtractMethodController >> coder: methodCoder [
	coder := methodCoder
]

{ #category : #executing }
GtExtractMethodController >> createModel [
	| model ast modelClass |
	model := RBClassModelFactory rbNamespace
		onEnvironment: RBBrowserEnvironment new.
	model name: 'Extract method'.
	ast := RBParser parseFaultyMethod: originalSource asString.
	modelClass := model classFor: coder classOrMetaClass.
	methodSelector := ast selector.
	(modelClass sourceCodeFor: ast selector) = originalSource asString
		ifFalse: [ modelClass
				compile: originalSource asString
				classified: coder category ].
	^ model
]

{ #category : #executing }
GtExtractMethodController >> execute [
	[ self saveSource.
	self createModel.
	self executeRefactoring ]
		on: Error
		do: [ :ex | ex return ]
]

{ #category : #executing }
GtExtractMethodController >> executeRefactoring [
	| refactoring newSource |
	refactoring := self refactoring.
	self setDefaultOptionsOn: refactoring.
	refactoring primitiveExecute.
	newSource := ((refactoring model classFor: coder classOrMetaClass)
		methodFor: methodSelector) source.
	self updateMethod: newSource
]

{ #category : #private }
GtExtractMethodController >> extractedSelector [
	^ (String
		streamContents:
			[ :stream | extractedSelectorKeywords do: [ :each | stream nextPutAll: each ] ])
		asSymbol
]

{ #category : #executing }
GtExtractMethodController >> extractionInterval [
	^ extractionInterval
		ifNil: [ | nodes |
			nodes := coder rbSelectedNodes.
			nodes isNil
				ifTrue: [ ^ 1 to: 0 ].
			extractionInterval := nodes first start to: nodes last stop ]
]

{ #category : #private }
GtExtractMethodController >> findExtractedSend [
	self sourceAst
		withAllNodesOfType: GtPharoMessageNode
		do: [ :each | 
			(each selector = self extractedSelector
				and: [ ((1 to: methodArguments size)
						allSatisfy: [ :i | 
							(each isBinary
								ifTrue: [ each value ]
								ifFalse: [ each values at: i ]) source
								= (methodArguments at: i) ])
						and: [ (each parent receiver isKindOf: GtPharoVariableNode)
								and: [ each parent receiver name value = 'self' ] ] ])
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #private }
GtExtractMethodController >> installRenamerAt: anInteger [
	| message interval |
	renameIndex := anInteger.
	anInteger isNil
		ifTrue: [ ^ self addRefactoringPreview ].
	message := self findExtractedSend.
	message isNil
		ifTrue: [ ^ self cancelRefactoring ].
	interval := (message selectorParts at: anInteger) sourceInterval.
	sourceElement editor moveCursorTo: interval first.
	renameAction := GtRenameAction
		locations: {interval}
		element: sourceElement.
	renameAction
		when: GtRenameActionAnnouncement
		do: [ :ann | 
			ann eventType = #textUpdated
				ifTrue: [ self updateSelector: renameAction newName ].
			ann eventType = #accept
				ifTrue: [ self
						installRenamerAt:
							(anInteger < extractedSelectorKeywords size
								ifTrue: [ anInteger + 1 ]
								ifFalse: [ nil ]) ].
			ann eventType = #cancel
				ifTrue: [ self cancelRefactoring ] ].
	renameAction install
]

{ #category : #testing }
GtExtractMethodController >> isRenaming [
	^ renameAction notNil and: [ renameAction isInstalled ]
]

{ #category : #executing }
GtExtractMethodController >> refactoring [
	| model |
	model := self createModel.
	^ RBExtractMethodRefactoring
		model: model
		extract: self extractionInterval
		from: methodSelector
		in: (model classFor: coder classOrMetaClass)
]

{ #category : #private }
GtExtractMethodController >> removeReorderParametersAttributes [
	coder sourceEditor text
		clearAttributes: [ :each | each isKindOf: GtReorderParametersAttribute ]
]

{ #category : #private }
GtExtractMethodController >> safeMethodName: methodName in: aModel [
	| modelClass index selector name argCount |
	modelClass := aModel classFor: coder classOrMetaClass.
	argCount := methodName arguments size.
	name := '_'.
	index := 0.
	[ selector := (String
		streamContents: [ :stream | 
			stream nextPutAll: name.
			argCount >= 1
				ifTrue: [ stream nextPut: $:.
					2 to: argCount do: [ :i | stream nextPutAll: '_:' ] ] ]) asSymbol.
	modelClass hierarchyDefinesMethod: selector ]
		whileTrue: [ name := name , index printString.
			index := index + 1 ].
	^ selector
]

{ #category : #executing }
GtExtractMethodController >> saveSource [
	originalSource := coder sourceEditor text copy
]

{ #category : #private }
GtExtractMethodController >> setBodyText: bodySource andAttributesAt: positions [
	| bodyText |
	bodyText := bodySource asRopedText.
	bodyText attributes: coder defaultTextAttributes.
	positions
		keysAndValuesDo: [ :i :each | 
			(bodyText from: each to: each)
				attributes:
					{GtCompletionPartAttribute new.
					(GtSelectorKeywordAttribute keywordIndex: i)} ].
	coder sourceEditor text: bodyText
]

{ #category : #private }
GtExtractMethodController >> setCoderText: aString [
	| text |
	text := aString asRopedText.
	text attributes: coder defaultTextAttributes.
	coder sourceEditor
		selectNone;
		text: text
]

{ #category : #private }
GtExtractMethodController >> setDefaultOptionsOn: aRefactoring [
	isExisting := false.
	aRefactoring
		setOption: #useExistingMethod
			toUse: [ :ref :sel | 
			extractedSelectorKeywords := sel keywords.
			isExisting := true ];
		setOption: #methodName
			toUse: [ :ref :methodName | 
			| selector |
			methodArguments := Array withAll: methodName arguments.
			selector := self safeMethodName: methodName in: ref model.
			extractedSelectorKeywords := selector keywords.
			methodName
				selector: selector;
				yourself ];
		setOption: #extractAssignment
			toUse: [ :ref :varName | 
			(aRefactoring model classFor: coder classOrMetaClass)
				definesVariable: varName ]
]

{ #category : #private }
GtExtractMethodController >> setPreviewOptionsOn: aRefactoring [
	aRefactoring
		setOption: #useExistingMethod toUse: [ :ref :sel | isExisting ];
		setOption: #methodName
			toUse: [ :ref :methodName | 
			methodName
				selector: self extractedSelector;
				arguments: methodArguments;
				yourself ];
		setOption: #extractAssignment
			toUse: [ :ref :varName | 
			(aRefactoring model classFor: coder classOrMetaClass)
				definesVariable: varName ]
]

{ #category : #private }
GtExtractMethodController >> sourceAst [
	^ GtPharoParser parse: coder source startingAt: GtPharoParser startingStateForMethod
]

{ #category : #accessing }
GtExtractMethodController >> sourceElement [
	^ sourceElement
]

{ #category : #accessing }
GtExtractMethodController >> sourceElement: textElement [
	sourceElement := textElement
]

{ #category : #private }
GtExtractMethodController >> swap: firstNode with: secondNode in: textEditor [
	textEditor deleter
		from: secondNode startPosition - 1 to: secondNode stopPosition;
		delete.
	textEditor inserter
		at: secondNode startPosition - 1;
		string: firstNode source;
		insert.
	textEditor deleter
		from: firstNode startPosition - 1 to: firstNode stopPosition;
		delete.
	textEditor inserter
		at: firstNode startPosition - 1;
		string: secondNode source;
		insert
]

{ #category : #private }
GtExtractMethodController >> swapParameterWithNext: anInteger [
	| message |
	self removeReorderParametersAttributes.
	self isRenaming
		ifTrue: [ renameAction uninstall ].
	message := self findExtractedSend.
	message isNil
		ifTrue: [ ^ self ].
	methodArguments swap: anInteger with: anInteger + 1.
	self
		swap: (message values at: anInteger)
		with: (message values at: anInteger + 1)
		in: coder sourceEditor.
	self addReorderParametersAttributes.
	renameIndex notNil
		ifTrue: [ self installRenamerAt: renameIndex ].
	self addRefactoringPreview
]

{ #category : #private }
GtExtractMethodController >> updateMethod: newSource [
	self setCoderText: newSource.
	isExisting
		ifTrue: [ ^ self ].
	extractedSelectorKeywords size > 1
		ifTrue: [ self addReorderParametersAttributes ].
	self installRenamerAt: 1.
	self addRefactoringPreview
]

{ #category : #private }
GtExtractMethodController >> updateSelector: aString [
	extractedSelectorKeywords at: renameIndex put: aString
]
