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
	aModel label: 'Trait methods'.
	self assert: aModel isSwitchedOn.
	
	^ aModel
]

{ #category : #examples }
GtFilterModelExamples >> invariableModel [
	<gtExample>
	| aModel |
	aModel := GtFilterInvariableModel new.
	aModel label: 'Stable tests'.
	
	^ aModel
]

{ #category : #examples }
GtFilterModelExamples >> itemsModel [
	<gtExample>
	| aModel |
	aModel := GtFilterItemsModel new.
	aModel
		items: {self textModel.
				self shortListModel.
				self booleanModel}.
	self assert: aModel items size equals: 3.

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
	aModel label: 'Side'.
	self
		assert: aModel items
		equals: ({'instance'.
				'class'} collect: #asFilterModelItem).
	self assert: aModel selectedItem equals: 'class' asFilterModelItem.

	^ aModel
]

{ #category : #examples }
GtFilterModelExamples >> textModel [
	<gtExample>
	| aModel |
	aModel := GtFilterTextModel new.
	aModel text: 'Object'.
	aModel label: 'Methods up to'.
	self assert: (aModel text equals: 'Object' asRopedText).

	^ aModel
]

{ #category : #examples }
GtFilterModelExamples >> toggleModel [
	<gtExample>
	| aModel |
	aModel := GtFilterToggleModel new.
	aModel label: 'Side'.
	aModel
		items: {GtFilterShortListInstanceSideItem new.
				GtFilterShortListClassSideItem new}.
	aModel selectFirstItem.

	^ aModel
]
