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
				self booleanModel.
				self invariableModel.
				self toggleModel.}.
	self assert: aModel items size equals: 5.

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
GtFilterModelExamples >> shortListModelWithIcons [
	<gtExample>
	| aModel |
	aModel := GtFilterShortListModel new.
	aModel
		items: {GtFilterModelClassItem new itemClass: Array.
				GtFilterModelClassItem new itemClass: OrderedCollection.
				GtFilterModelClassItem new itemClass: TGtAnnouncer.
				GtFilterModelClassItem new itemClass: Object.
				GtFilterModelClassItem new itemClass: ProtoObject}.
	aModel selectFirstItem.
	aModel label: 'Classes'.
	self
		assert: aModel items
		equals: {GtFilterModelClassItem new itemClass: Array.
				GtFilterModelClassItem new itemClass: OrderedCollection.
				GtFilterModelClassItem new itemClass: TGtAnnouncer.
				GtFilterModelClassItem new itemClass: Object.
				GtFilterModelClassItem new itemClass: ProtoObject}.
	self
		assert: aModel selectedItem
		equals: (GtFilterModelClassItem new itemClass: Array).

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
		items: {GtFilterModelInstanceSideItem new.
				GtFilterModelClassSideItem new}.
	aModel selectFirstItem.

	^ aModel
]
