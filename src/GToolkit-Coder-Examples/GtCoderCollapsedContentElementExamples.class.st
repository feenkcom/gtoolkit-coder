Class {
	#name : #GtCoderCollapsedContentElementExamples,
	#superclass : #GtCoderContentElementExamples,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #examples }
GtCoderCollapsedContentElementExamples >> forMethodCoder [
	<gtExample>
	| aMethodCoder aContentElement |
	
	aMethodCoder := GtMethodCoder forMethod: (BlElement >> #position:extent:).
	
	aContentElement := GtCoderCollapsedContentElement new coder: aMethodCoder.

	^ aContentElement
]
