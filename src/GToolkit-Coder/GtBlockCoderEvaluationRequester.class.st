Class {
	#name : #GtBlockCoderEvaluationRequester,
	#superclass : #GtSourceCoderRequester,
	#category : #'GToolkit-Coder'
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
