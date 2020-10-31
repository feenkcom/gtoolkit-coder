Class {
	#name : #GtExpandableCoderElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #'as yet unclassified' }
GtExpandableCoderElementExamples >> forCollapsedMethodCoder [
	<gtExample>
	| anElement aCoder |
	aCoder := GtMethodCoder forMethod: GtMethodCoderExamples >> #example.
	anElement := GtExpandableCoderElement new.
	anElement coderUIModel: aCoder asCoderUIModel.
	self assert: anElement isExpanded not.
	^ anElement
]
