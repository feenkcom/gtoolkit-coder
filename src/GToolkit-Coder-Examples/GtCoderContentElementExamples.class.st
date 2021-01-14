Class {
	#name : #GtCoderContentElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #examples }
GtCoderContentElementExamples >> methodCoder [
	<gtExample>
	
	^ GtMethodCoder forMethod: (BlElement >> #position:extent:context:)
]
