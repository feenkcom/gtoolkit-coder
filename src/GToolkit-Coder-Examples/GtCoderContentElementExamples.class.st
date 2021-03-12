Class {
	#name : #GtCoderContentElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #examples }
GtCoderContentElementExamples >> methodCoder [
	<gtExample>
	
	^ GtPharoMethodCoder forMethod: (BlElement >> #position:extent:context:)
]
