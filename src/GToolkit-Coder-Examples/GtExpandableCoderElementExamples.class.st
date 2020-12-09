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
	anElement := GtExpandableSourceCoderElement new.
	anElement coderUIModel: (aCoder asCoderUIModel expanded: false).
	self assert: anElement isExpanded not.
	^ anElement
]

{ #category : #'as yet unclassified' }
GtExpandableCoderElementExamples >> forExpandedMethodCoder [
	<gtExample>
	| anElement aCoder |
	aCoder := GtMethodCoder forMethod: GtMethodCoderExamples >> #example.
	anElement := GtExpandableSourceCoderElement new.
	anElement coderUIModel: (aCoder asCoderUIModel expanded: true).
	self assert: anElement isExpanded.
	^ anElement
]
