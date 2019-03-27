Class {
	#name : #GtBlockCoderEvaluationRequester,
	#superclass : #GtMethodCoderRequester,
	#category : #'GToolkit-Coder'
}

{ #category : #requester }
GtBlockCoderEvaluationRequester >> text [
	^ coder newSource
]
