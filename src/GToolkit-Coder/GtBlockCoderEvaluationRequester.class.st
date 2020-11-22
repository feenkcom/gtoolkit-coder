Class {
	#name : #GtBlockCoderEvaluationRequester,
	#superclass : #GtSourceCoderEvaluationRequester,
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
