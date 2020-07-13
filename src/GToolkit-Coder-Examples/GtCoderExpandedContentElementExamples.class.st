Class {
	#name : #GtCoderExpandedContentElementExamples,
	#superclass : #GtCoderContentElementExamples,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #examples }
GtCoderExpandedContentElementExamples >> forMethodCoder [
	<gtExample>
	| aMethodCoder aContentElement |
	
	aMethodCoder := GtMethodCoder forMethod: (BlElement >> #position:extent:).
	
	aContentElement := GtCoderExpandedContentElement new coder: aMethodCoder.

	^ aContentElement
]
