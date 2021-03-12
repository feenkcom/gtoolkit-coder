Class {
	#name : #GtCoderCollapsedContentElementExamples,
	#superclass : #GtCoderContentElementExamples,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #'examples - looks' }
GtCoderCollapsedContentElementExamples >> forExampleCoder [
	<gtExample>
	| aMethodCoder aContentElement |
	
	aMethodCoder := GtPharoMethodCoder forMethod: self class >> #greenExample.
	aContentElement := GtSourceCoderCollapsedContentElement new
		coderUIModel: aMethodCoder asCoderUIModel.
	aContentElement look: GtSourceCoderCollapsedTextAndExampleLook.

	^ aContentElement
]

{ #category : #examples }
GtCoderCollapsedContentElementExamples >> forMethodCoder [
	<gtExample>
	| aMethodCoder aContentElement |
	aMethodCoder := GtPharoMethodCoder
		forMethod: BlElement >> #position:extent:context:.
	aContentElement := GtSourceCoderCollapsedContentElement new
		coderUIModel: aMethodCoder asCoderUIModel.
	
	aContentElement look: GtMethodCoderHeaderLook + GtSourceCoderCollapsedTextLook.
	
	^ aContentElement
]

{ #category : #'example - samples' }
GtCoderCollapsedContentElementExamples >> greenExample [
	<gtExample>
	^ 42
]

{ #category : #'example - samples' }
GtCoderCollapsedContentElementExamples >> noExample [
	^ 42
]

{ #category : #'examples - looks' }
GtCoderCollapsedContentElementExamples >> textAndExampleLook_withExampleMethod [
	<gtExample>
	| aMethodCoder aContentElement |
	aMethodCoder := GtPharoMethodCoder forMethod: self class >> #greenExample.
	aMethodCoder example run.
	aContentElement := GtSourceCoderCollapsedContentElement new
		coderUIModel: aMethodCoder asCoderUIModel.
	aContentElement addLook: BrLayoutResizerLook inherit.
	aContentElement look: GtSourceCoderCollapsedTextAndExampleLook.
	^ aContentElement
]

{ #category : #'examples - looks' }
GtCoderCollapsedContentElementExamples >> textAndExampleLook_withRegularMethod [
	<gtExample>
	| aMethodCoder aContentElement |
	aMethodCoder := GtPharoMethodCoder forMethod: self class >> #noExample.
	aContentElement := GtSourceCoderCollapsedContentElement new
		coderUIModel: aMethodCoder asCoderUIModel.
	aContentElement addLook: BrLayoutResizerLook inherit.
	aContentElement look: GtSourceCoderCollapsedTextAndExampleLook.
	^ aContentElement
]
