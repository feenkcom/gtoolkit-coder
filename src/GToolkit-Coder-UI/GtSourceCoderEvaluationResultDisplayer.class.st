Class {
	#name : #GtSourceCoderEvaluationResultDisplayer,
	#superclass : #Object,
	#instVars : [
		'editorElement',
		'updateRequester',
		'evaluationResult',
		'evaluationAttributes'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #private }
GtSourceCoderEvaluationResultDisplayer >> addAttributesFor: anEvaluationResult within: aTextInterval [
	self subclassResponsibility
]

{ #category : #'api - evaluation result' }
GtSourceCoderEvaluationResultDisplayer >> displayResult: anEvaluationResult [
	self
		assert: [ anEvaluationResult notNil ]
		description: [ 'Evaluation result must not be nil' ].

	evaluationResult = anEvaluationResult
		ifTrue: [ ^ self ].
	evaluationResult := anEvaluationResult.
	updateRequester requestUpdate
]

{ #category : #'api - evaluation result' }
GtSourceCoderEvaluationResultDisplayer >> displayResultSynchronously: anEvaluationResult [
	self
		assert: [ anEvaluationResult notNil ]
		description: [ 'Evaluation result must not be nil' ].

	evaluationResult = anEvaluationResult
		ifTrue: [ ^ self ].
	evaluationResult := anEvaluationResult.
	self primitiveUpdateResult
]

{ #category : #accessing }
GtSourceCoderEvaluationResultDisplayer >> editorElement [
	^ editorElement
]

{ #category : #accessing }
GtSourceCoderEvaluationResultDisplayer >> editorElement: anObject [
	editorElement := anObject.
	updateRequester element: editorElement
]

{ #category : #accessing }
GtSourceCoderEvaluationResultDisplayer >> evaluationResult [
	^ evaluationResult
]

{ #category : #'api - evaluation result' }
GtSourceCoderEvaluationResultDisplayer >> hideResult [
	evaluationResult
		ifNil: [ ^ self ].
	evaluationResult := nil.
	updateRequester requestUpdate
]

{ #category : #'api - evaluation result' }
GtSourceCoderEvaluationResultDisplayer >> hideResultSynchronously [
	evaluationResult
		ifNil: [ ^ self ].
	evaluationResult := nil.
	self primitiveUpdateResult
]

{ #category : #initialization }
GtSourceCoderEvaluationResultDisplayer >> initialize [
	super initialize.
	
	editorElement := nil.
	evaluationResult := nil.
	
	updateRequester := GtPhlowUpdateRequester new.
	updateRequester action: [ self primitiveUpdateResult ].
	evaluationAttributes := #()
]

{ #category : #private }
GtSourceCoderEvaluationResultDisplayer >> primitiveAddResult: anEvaluationResult [
	| anEvaluatedSource anEvaluatedInterval theSourceStartInText theSourceEndInText |
	
	anEvaluatedSource := anEvaluationResult sourceString.
	anEvaluatedSource ifEmpty: [ ^ self ].
	anEvaluatedInterval := anEvaluationResult sourceInterval.
	
	theSourceStartInText := self text finder
		caseSensitiveSubstring: anEvaluatedSource;
		startAtPosition: anEvaluatedInterval first;
		searchClosest.
	
	"what did we evaluate?"
	theSourceStartInText isZero
		ifTrue: [ ^ self ].

	theSourceEndInText := (theSourceStartInText + anEvaluatedSource size - 1) min: self text size.
	
	evaluationAttributes := self
		addAttributesFor: anEvaluationResult
		within: (theSourceStartInText to: theSourceEndInText)
]

{ #category : #private }
GtSourceCoderEvaluationResultDisplayer >> primitiveRemoveResult [
	self text removeAttributes: evaluationAttributes.
	evaluationAttributes := #()
]

{ #category : #private }
GtSourceCoderEvaluationResultDisplayer >> primitiveUpdateResult [
	self primitiveRemoveResult.
	evaluationResult
		ifNotNil: [ :anEvaluationResult | self primitiveAddResult: anEvaluationResult ]
]

{ #category : #accessing }
GtSourceCoderEvaluationResultDisplayer >> text [
	^ self editorElement text
]
