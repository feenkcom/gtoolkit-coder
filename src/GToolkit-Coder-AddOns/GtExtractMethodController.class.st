Class {
	#name : #GtExtractMethodController,
	#superclass : #GtSourceCoderRefactoringController,
	#instVars : [
		'methodArguments',
		'methodSelector',
		'isExisting',
		'extractedSelectorKeywords',
		'renameAction',
		'renameIndex',
		'extractionInterval'
	],
	#category : #'GToolkit-Coder-AddOns-Extract method'
}

{ #category : #private }
GtExtractMethodController >> addRefactoringPreview [
	| message refactoring |

	message := self findExtractedSend.
	message
		"refactoring failed"
		ifNil: [ ^ self ].
	
	refactoring := self refactoring.

	self setPreviewOptionsOn: refactoring.
	self
		addRefactoringChangesPreview: refactoring
		at: message stopPosition
		whenComplete: [
			self removeRefactoringAttribute.
			self allowSave ]
]

{ #category : #private }
GtExtractMethodController >> addReorderParametersAttributes [
	| message text |
	message := self findExtractedSend.
	message isNil
		ifTrue: [ ^ self ].
	text := self sourceText.
	(message isBinary
		ifTrue: [ {message value} ]
		ifFalse: [ message values ])
		keysAndValuesDo: [ :i :each | 
			i > 1
				ifTrue: [ (text from: each startPosition - 1 to: each startPosition - 1)
						attributes:
							{(GtExtractMethodReorderParametersAttribute
								action: [ self swapParameterWithNext: i - 1 ]
								icon: BrGlamorousVectorIcons left)} ].
			i < message values size
				ifTrue: [ (text from: each stopPosition to: each stopPosition)
						attributes:
							{(GtExtractMethodReorderParametersAttribute
								action: [ self swapParameterWithNext: i ]
								icon: BrGlamorousVectorIcons right)} ] ]
]

{ #category : #executing }
GtExtractMethodController >> cancelRefactoring [
	self isRenaming
		ifTrue: [ renameAction cancel ].
	
	self restoreText.
	self allowSave
]

{ #category : #executing }
GtExtractMethodController >> createModel [
	| model ast modelClass |
	
	model := RBClassModelFactory rbNamespace
		onEnvironment: RBBrowserEnvironment new.
	model name: self refactoringName.
	
	modelClass := model classFor: coder behavior.
	
	"this is just to extract the method name"
	ast := RBParser parseFaultyMethod: originalSource asString.
	methodSelector := ast selector.

	(modelClass sourceCodeFor: methodSelector) = originalSource asString
		ifFalse: [ modelClass
				compile: originalSource asString
				classified: coder protocol ].
	^ model
]

{ #category : #executing }
GtExtractMethodController >> executeRefactoring [
	| refactoring newSource |

	refactoring := self refactoring.
	self setDefaultOptionsOn: refactoring.
	refactoring primitiveExecute.

	newSource := ((refactoring model classFor: coder behavior) methodFor: methodSelector) source.
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
			nodes := coder extractableNodesFrom: self sourceElement textualCoderViewModel.
			nodes ifEmpty: [ ^ 1 to: 0 ].
			extractionInterval := nodes first startPosition to: nodes last stopPosition ]
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
	
	sourceElement editor moveCursorTo: ((interval first - 1) max: 0).
	
	renameAction := GtRenameAction
		locations: { interval }
		element: sourceElement.
	
	renameAction selectAll: true.

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
		in: (model classFor: coder behavior)
]

{ #category : #executing }
GtExtractMethodController >> refactoringFailed [
	self sourceElement textualCoderViewModel allowSaveDueTo: self
]

{ #category : #accessing }
GtExtractMethodController >> refactoringName [
	^ 'Extract method'
]

{ #category : #private }
GtExtractMethodController >> removeReorderParametersAttributes [
	self sourceText
		clearAttributes: [ :each | each isKindOf: GtExtractMethodReorderParametersAttribute ]
]

{ #category : #private }
GtExtractMethodController >> safeMethodName: methodName in: aModel [
	| modelClass index selector name argCount |
	modelClass := aModel classFor: coder behavior.
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
GtExtractMethodController >> safelyExecute [
	self createModel.
	self executeRefactoring
]

{ #category : #private }
GtExtractMethodController >> setBodyText: bodySource andAttributesAt: positions [
	| bodyText |
	bodyText := bodySource asRopedText.
	positions
		keysAndValuesDo: [ :i :each | 
			(bodyText from: each to: each)
				attributes:
					{GtCompletionPartAttribute new.
					(GtExtractMethodSelectorKeywordAttribute keywordIndex: i)} ].
	self sourceEditor text: bodyText
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
			toUse:
				[ :ref :varName | (aRefactoring model classFor: coder behavior) definesVariable: varName ]
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
			toUse:
				[ :ref :varName | (aRefactoring model classFor: coder behavior) definesVariable: varName ]
]

{ #category : #private }
GtExtractMethodController >> sourceAst [
	^ GtPharoParser
		parse: self sourceText characters asString
		startingAt: GtPharoParser startingStateForMethod
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
		in: self sourceEditor.
	self addReorderParametersAttributes.
	renameIndex notNil
		ifTrue: [ self installRenamerAt: renameIndex ].
	self addRefactoringPreview
]

{ #category : #private }
GtExtractMethodController >> updateMethod: newSource [
	self sourceEditor deselecter all deselect.
	self setText: newSource.

	"refactoring decided that there is an existing method that can be used instead
	of creating a new one. In this case there is no need to spawn a renamer"
	isExisting
		ifTrue: [ ^ self ].

	"At this point saving is undefined, we disable it until refactoring is applied or canceled"
	self preventSave.
	
	extractedSelectorKeywords size > 1
		ifTrue: [ self addReorderParametersAttributes ].

	self installRenamerAt: 1.
	self addRefactoringPreview
]

{ #category : #private }
GtExtractMethodController >> updateSelector: aString [
	extractedSelectorKeywords at: renameIndex put: aString
]
