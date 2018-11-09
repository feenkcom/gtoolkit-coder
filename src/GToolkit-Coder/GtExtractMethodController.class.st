Class {
	#name : #GtExtractMethodController,
	#superclass : #Object,
	#instVars : [
		'coder',
		'sourceElement',
		'model',
		'refactoring',
		'methodSelector',
		'isExisting',
		'extractedSelector',
		'extractedCoder',
		'eventHandlers',
		'renameAction'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #private }
GtExtractMethodController >> addExtractedMethodAttributeTo: bodyText from: startInteger to: endInteger [
	(bodyText from: startInteger to: endInteger)
		attributes:
			{(BrTextExpandButtonAttribute new
				beNotOverwritableByStyler;
				isExpanded: true;
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ | editorElement |
							extractedCoder expanded: true.
							editorElement := extractedCoder asElement.
							editorElement border: (BlBorder paint: Color veryLightGray width: 1).
							editorElement
								margin:
									(BlInsets
										top: 0
										right: 10
										bottom: 10
										left: 10) ] ])}
]

{ #category : #accessing }
GtExtractMethodController >> coder [
	^ coder
]

{ #category : #accessing }
GtExtractMethodController >> coder: methodCoder [
	coder := methodCoder
]

{ #category : #private }
GtExtractMethodController >> createExtractedCoder: aString [
	| extractedSource extractedAst |
	extractedAst := GtPharoParser parse: aString.
	extractedSource := String
		streamContents: [ :stream | 
			| lastIndex selectorPart |
			lastIndex := 1.
			selectorPart := extractedAst variables isEmpty
				ifTrue: [ '_' ]
				ifFalse: [ '_:' ].
			extractedAst selectorParts
				do: [ :each | 
					stream
						nextPutAll: (aString copyFrom: lastIndex to: each startPosition - 1);
						nextPutAll: selectorPart.
					lastIndex := each stopPosition + 1 ].
			stream nextPutAll: (aString copyFrom: lastIndex to: aString size) ].
	extractedCoder := GtMethodCoder forClass: coder classOrMetaClass source: extractedSource.
	extractedCoder buildSource
]

{ #category : #executing }
GtExtractMethodController >> createModel [
	| change |
	model := RBClassModelFactory rbNamespace onEnvironment: RBBrowserEnvironment new.
	model name: 'Extract method'.
	change := self modelClass compile: coder newMethodSource asString classified: coder category.
	methodSelector := change selector
]

{ #category : #'event handling' }
GtExtractMethodController >> cursorMoved: anEvent [
	| attribute |
	(renameAction notNil and: [ renameAction isInstalled ])
		ifTrue: [ ^ self ].
	attribute := (coder sourceEditor text attributesAt: anEvent newIndex) detect: [ :each | each isKindOf: GtSelectorKeywordAttribute ] ifNone: [ nil ].
	attribute isNil
		ifTrue: [ ^ self ].
	renameAction := GtCompositeRenameAction locations: {(self intervalAt: anEvent newIndex)} element: sourceElement.
	renameAction addLocations: {(self keywordStartPositionFor: attribute index)} to: extractedCoder patternEditor.
	renameAction install
]

{ #category : #'event handling' }
GtExtractMethodController >> editorUpdated [
	| text |
	text := coder sourceEditor text.
	1 to: text size do: [ :i | 
		((text attributesAt: i) anySatisfy: [ :each | each isKindOf: GtSelectorKeywordAttribute ])
			ifTrue: [ ^ self ] ].
	self uninstallHandlers
]

{ #category : #executing }
GtExtractMethodController >> execute [
	[ self createModel.
	self executeRefactoring.
	self updateEditors ]
		on: Error
		do: [ :ex | ex return ]
]

{ #category : #executing }
GtExtractMethodController >> executeRefactoring [
	| offset interval |
	interval := coder selectedSourceInterval.
	offset := coder patternSource size + 1.
	refactoring := RBExtractMethodRefactoring
		model: model
		extract: (interval first + offset to: interval last + offset)
		from: methodSelector
		in: self modelClass.
	self setRefactoringOptions.
	refactoring primitiveExecute
]

{ #category : #'event handling' }
GtExtractMethodController >> installHandlers [
	eventHandlers := {(BlEventHandler
		on: BrTextEditorCursorMovedEvent
		do: [ :event | self cursorMoved: event ]).
	(BlEventHandler
		on: BrTextEditorDeletedEvent
		do: [ :event | self editorUpdated ]).
	(BlEventHandler
		on: BrTextEditorInsertedEvent
		do: [ :event | self editorUpdated ])}.
	eventHandlers do: [ :each | coder sourceEditor addEventHandler: each ]
]

{ #category : #'event handling' }
GtExtractMethodController >> intervalAt: anInteger [
	| text first last |
	text := coder sourceEditor text.
	first := anInteger - 1.
	last := anInteger + 1.
	[ first >= 1 and: [ (text attributesAt: first) anySatisfy: [ :each | each isKindOf: GtSelectorKeywordAttribute ] ] ] whileTrue: [ first := first - 1 ].
	first := first + 1.
	[ last <= text size and: [ (text attributesAt: last) anySatisfy: [ :each | each isKindOf: GtSelectorKeywordAttribute ] ] ] whileTrue: [ last := last + 1 ].
	(last <= text size and: [ (text at: last) = $: ])
		ifFalse: [ last := last - 1 ].
	^ first to: last
]

{ #category : #'event handling' }
GtExtractMethodController >> keywordStartPositionFor: anInteger [
	| ast |
	ast := GtPharoParser parse: extractedCoder patternSource startingAt: GtPharoParser startingStateForMethodPattern.
	^ (ast selectorParts at: anInteger) startPosition
]

{ #category : #private }
GtExtractMethodController >> modelClass [
	^ model classFor: coder classOrMetaClass
]

{ #category : #private }
GtExtractMethodController >> setBodyText: bodySource andAttributesAt: positions from: startInteger to: endInteger [
	| bodyText start |
	bodyText := bodySource asRopedText.
	bodyText attributes: coder defaultTextAttributes.
	start := endInteger - 1.
	[ start >= startInteger and: [ (bodyText at: start) ~= Character cr ] ] whileTrue: [ start := start - 1 ].
	positions
		keysAndValuesDo: [ :i :each | 
			(bodyText from: each to: each)
				attributes:
					{GtCompletionPartAttribute new.
					(GtSelectorKeywordAttribute keywordIndex: i)} ].
	self addExtractedMethodAttributeTo: bodyText from: start + 1 to: endInteger.
	coder sourceEditor text: bodyText
]

{ #category : #private }
GtExtractMethodController >> setRefactoringOptions [
	isExisting := false.
	refactoring
		setOption: #useExistingMethod
			toUse: [ :ref :sel | 
			extractedSelector := sel.
			isExisting := true ];
		setOption: #methodName
			toUse: [ :ref :methodName | 
			extractedSelector := ref uniqueMethodNameFor: methodName arguments size.
			methodName
				selector: extractedSelector;
				yourself ];
		setOption: #extractAssignment toUse: [ :ref :varName | self modelClass definesVariable: varName ]
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
GtExtractMethodController >> splitBodyFrom: aString [
	| ast index |
	ast := GtPharoParser parse: aString.
	index := coder findSeparatorBetweenPatternAndBodyIn: ast.
	index := coder skipBlankLinesIn: aString at: index.
	^ aString allButFirst: index - 1
]

{ #category : #'event handling' }
GtExtractMethodController >> uninstallHandlers [
	eventHandlers do: [ :each | coder sourceEditor removeEventHandler: each ]
]

{ #category : #private }
GtExtractMethodController >> updateBodySource: aString [
	| ast bodySource message positions offset |
	ast := GtPharoParser parse: aString startingAt: GtPharoParser startingStateForMethodSequence.
	ast
		withAllNodesOfType: GtPharoMessageNode
		do: [ :node | 
			node selector = extractedSelector
				ifTrue: [ message := node ] ].
	extractedSelector isKeyword
		ifTrue: [ bodySource := String
				streamContents: [ :stream | 
					| lastIndex |
					positions := OrderedCollection new.
					lastIndex := 1.
					message selectorParts
						do: [ :each | 
							stream
								nextPutAll: (aString copyFrom: lastIndex to: each startPosition - 1);
								nextPut: $_.
							positions add: stream position.
							lastIndex := each stopPosition ].
					stream nextPutAll: (aString allButFirst: lastIndex - 1) ].
			offset := message selectorParts last stopPosition - positions last - 1 ]
		ifFalse: [ positions := {message selectorPart startPosition}.
			bodySource := (aString first: positions first - 1) , '_' , (aString allButFirst: message selectorPart stopPosition).
			offset := message selectorPart value size - 1 ].
	self
		setBodyText: bodySource
		andAttributesAt: positions
		from: message parent receiver startPosition
		to: message stopPosition - offset.
	self installHandlers.
	coder sourceEditor selecter
		overwrite;
		from: positions first - 1 to: positions first;
		select
]

{ #category : #executing }
GtExtractMethodController >> updateEditors [
	| extractedSource newSource |
	newSource := (self modelClass methodFor: methodSelector) source.
	extractedSource := (self modelClass methodFor: extractedSelector) ifNotNil: [ :method | method source ].
	self updateMethod: newSource extracted: extractedSource
]

{ #category : #private }
GtExtractMethodController >> updateMethod: newSource extracted: extractedSource [
	| bodySource |
	coder sourceEditor selectNone.
	bodySource := self splitBodyFrom: newSource.
	isExisting
		ifTrue: [ coder sourceEditor text: (bodySource asRopedText attributes: coder defaultTextAttributes).
			^ self ].
	self createExtractedCoder: extractedSource.
	self updateBodySource: bodySource
]
