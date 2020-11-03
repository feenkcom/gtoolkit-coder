Class {
	#name : #GtMethodCoderTagsElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #examples }
GtMethodCoderTagsElementExamples >> forMethodCoder [
	<gtExample>
	| aMethodCoder theTagsElement |
	aMethodCoder := GtMethodCoder forMethod: GtMethodCoderExamples >> #forExampleMethodCoder.
	theTagsElement := GtMethodCoderTagsElement new methodCoderUIModel: aMethodCoder asCoderUIModel.
	^ theTagsElement
]
