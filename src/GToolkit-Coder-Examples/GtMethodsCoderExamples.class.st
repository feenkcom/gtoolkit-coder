Class {
	#name : #GtMethodsCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #'as yet unclassified' }
GtMethodsCoderExamples >> methodsCoderWithClass [
	<gtExample>
	^ GtMethodsCoder forClass: Object
]

{ #category : #'as yet unclassified' }
GtMethodsCoderExamples >> methodsCoderWithExplicitMethods [
	<gtExample>
	^ GtMethodsCoder forMethods: { Object>>#printString . Object >>#printOn: }
]
