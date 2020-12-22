Class {
	#name : #GtSourceCoderEvaluationPrinter,
	#superclass : #GtSourceCoderEvaluationResultDisplayer,
	#category : #'GToolkit-Coder-UI-Coder - Source'
}

{ #category : #private }
GtSourceCoderEvaluationPrinter >> addAttributesFor: anEvaluationResult within: aTextInterval [
	| theAttributes |
	
	theAttributes := #().
	
	anEvaluationResult isSuccess
		ifTrue: [
			| aPrintAttribute | 

			aPrintAttribute := (GtCoderPrintStringAttribute forObject: anEvaluationResult value).

			(self text 
				from: aTextInterval last
				to: aTextInterval last) attribute: aPrintAttribute.
			
			theAttributes := { aPrintAttribute } ].

	^ theAttributes
]
