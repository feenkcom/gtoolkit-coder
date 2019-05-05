Class {
	#name : #GtBlockCoderEvaluationRequester,
	#superclass : #GtMethodCoderRequester,
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtBlockCoderEvaluationRequester >> source: aString [
	"noop"

	self flag: 'should be in superclass?'
]

{ #category : #requester }
GtBlockCoderEvaluationRequester >> text [
	^ coder newSource
]
