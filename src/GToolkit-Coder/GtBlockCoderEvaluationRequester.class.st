Class {
	#name : #GtBlockCoderEvaluationRequester,
	#superclass : #GtSourceCoderBasicEvaluationRequester,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtBlockCoderEvaluationRequester >> source: aString [
	"noop"

	self flag: 'should be in superclass?'
]

{ #category : #requester }
GtBlockCoderEvaluationRequester >> text [
	^ coder blockSource
]
