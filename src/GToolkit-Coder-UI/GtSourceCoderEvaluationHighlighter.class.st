Class {
	#name : #GtSourceCoderEvaluationHighlighter,
	#superclass : #GtSourceCoderEvaluationResultDisplayer,
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #'private - ui' }
GtSourceCoderEvaluationHighlighter >> addAttributesFor: anEvaluationResult within: aTextInterval [
	| theAttributes |
	theAttributes := #().

	anEvaluationResult isSuccess
		ifTrue: [ | aResultButtonAttribute |
			aResultButtonAttribute := GtPlaygroundEvaluatedCodeButtonAttribute new
					result: anEvaluationResult value;
					coder: anEvaluationResult sourceCoder;
					beNotOverwritableByStyler.	"Pass the coder to get the spawn destination"

			(self text from: aTextInterval last to: aTextInterval last)
				attribute: aResultButtonAttribute.

			theAttributes := {aResultButtonAttribute} ].

	^ theAttributes
]
