Class {
	#name : #GtMethodCoderTagsElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Source Coder - UI'
}

{ #category : #examples }
GtMethodCoderTagsElementExamples >> forMethodCoder [
	<gtExample>
	| aMethodCoder theTagsElement |
	aMethodCoder := GtPharoMethodCoder forMethod: GtPharoMethodCoderExamples >> #forExampleMethodCoder.
	theTagsElement := GtMethodCoderTagsElement new methodCoderUIModel: aMethodCoder asCoderUIModel.
	^ theTagsElement
]
