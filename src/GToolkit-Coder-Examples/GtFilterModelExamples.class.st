Class {
	#name : #GtFilterModelExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters - New'
}

{ #category : #examples }
GtFilterModelExamples >> booleanModel [
	<gtExample>
	| aModel |
	aModel := GtFilterBooleanModel new.
	aModel switchedOn: true.
	self assert: aModel isSwitchedOn.
	
	^ aModel
]

{ #category : #examples }
GtFilterModelExamples >> shortListModel [
	<gtExample>
	| aModel |
	aModel := GtFilterShortListModel new.
	aModel
		items: {'instance'.
				'class'}.
	aModel selectedItem: 'class'.
	self
		assert: aModel items
		equals: ({'instance'.
				'class'} collect: #asFilterShortListModelItem).
	self assert: aModel selectedItem equals: 'class' asFilterShortListModelItem.

	^ aModel
]

{ #category : #examples }
GtFilterModelExamples >> textModel [
	<gtExample>
	| aModel |
	aModel := GtFilterTextModel new.
	aModel text: 'Object'.
	self assert: (aModel text equals: 'Object' asRopedText).

	^ aModel
]
