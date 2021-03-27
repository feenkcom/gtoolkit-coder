Class {
	#name : #GtCoderExpandedContentElementExamples,
	#superclass : #GtCoderContentElementExamples,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #examples }
GtCoderExpandedContentElementExamples >> forMethodCoder [
	<gtExample>
	| aMethodCoder aContentElement |
	aMethodCoder := GtPharoMethodCoder
		forMethod: BlElement >> #position:extent:context:.
	aContentElement := GtSourceCoderExpandedContentElement new
		coderUIModel: aMethodCoder asCoderUIModel.
	aContentElement aptitude: GtMethodCoderHeaderAptitude + GtSourceCoderEditorAptitude.
	^ aContentElement
]
