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
		ifTrue: [
			| aResultButtonAttribute | 

			aResultButtonAttribute := GtPlaygroundEvaluatedCodeButtonAttribute new 
				result: anEvaluationResult value;
				coder: anEvaluationResult sourceCoder; "Pass the coder to get the spawn destination"
				beNotOverwritableByStyler.

			(self text 
				from: aTextInterval last
				to: aTextInterval last) attribute: aResultButtonAttribute.

			theAttributes := { aResultButtonAttribute } ]
		ifFalse: [
			anEvaluationResult isSyntaxError
				ifTrue: [
					theAttributes := {
						BlTextDecorationAttribute new underline color: Color red; beNotOverwritableByStyler.
						(GtSourceCoderErrorAttribute for: 'Syntax error') beNotOverwritableByStyler
					}.

					self text
						attributes: theAttributes
						from: aTextInterval first
						to: aTextInterval last ] ].

	^ theAttributes
]
