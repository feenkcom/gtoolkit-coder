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
GtFilterModelExamples >> shortListModelPluggableItems [
	<gtExample>
	| aModel allItems aCollection anIconBuilder aLabelBuilder |
	aModel := GtFilterShortListModel new.

	aCollection := {Array.
			OrderedCollection.
			TGtAnnouncer.
			Object.
			ProtoObject}.
	anIconBuilder := [ :aClass | 
		aClass gtSystemIconName
			ifNotNil: [ :anIconName | aClass gtSafeIconNamed: anIconName ] ].
	aLabelBuilder := [ :aClass | aClass name ].
	allItems := GtFilterModelPluggableItem
			forCollection: aCollection
			icon: anIconBuilder
			label: aLabelBuilder.
	
	aModel items: allItems.
	aModel selectFirstItem.
	aModel label: 'Classes'.
	
	self
		assert: aModel selectedItem
		equals: (GtFilterModelPluggableItem new
				object: Array;
				icon: anIconBuilder;
				label: aLabelBuilder).
	self assert: aModel selectedItem icon isNotNil.

	^ aModel
]

{ #category : #examples }
GtFilterModelExamples >> shortListModelPluggableItemsWithIconAndLabelBuilders [
	<gtExample>
	| aModel aCollection anIconBuilder aLabelBuilder |
	aModel := GtFilterShortListModel new.

	aCollection := {Array.
			OrderedCollection.
			TGtAnnouncer.
			Object.
			ProtoObject}.
	anIconBuilder := [ :aClass | 
		aClass gtSystemIconName
			ifNotNil: [ :anIconName | aClass gtSafeIconNamed: anIconName ] ].
	aLabelBuilder := [ :aClass | aClass name ].
	
	aModel items: aCollection icon: anIconBuilder label: aLabelBuilder.
	aModel selectFirstItem.
	aModel label: 'Classes'.
	
	self
		assert: aModel selectedItem
		equals: (GtFilterModelPluggableItem new
				object: Array;
				icon: anIconBuilder;
				label: aLabelBuilder).
	self assert: aModel selectedItem icon isNotNil.
	self assert: aModel selectedItem label equals: 'Array'.

	^ aModel
]

{ #category : #examples }
GtFilterModelExamples >> shortListModelPluggableItemsWithoutIconBuilder [
	<gtExample>
	| aModel aCollection aLabelBuilder |
	aModel := GtFilterShortListModel new.

	aCollection := {Array.
			OrderedCollection.
			TGtAnnouncer.
			Object.
			ProtoObject}.
	aLabelBuilder := [ :aClass | '+ ', aClass name ].
	
	aModel items: aCollection label: aLabelBuilder.
	aModel selectFirstItem.
	aModel label: 'Classes'.
	
	self
		assert: aModel selectedItem
		equals: (GtFilterModelPluggableItem new
				object: Array;
				label: aLabelBuilder).
	self assert: aModel selectedItem icon isNil.
	self assert: aModel selectedItem label equals: '+ Array'.

	^ aModel
]

{ #category : #examples }
GtFilterModelExamples >> shortListModelPluggableItemsWithoutLabelBuilder [
	<gtExample>
	| aModel aCollection anIconBuilder |
	aModel := GtFilterShortListModel new.

	aCollection := {Array.
			OrderedCollection.
			TGtAnnouncer.
			Object.
			ProtoObject}.
	anIconBuilder := [ :aClass | 
		aClass gtSystemIconName
			ifNotNil: [ :anIconName | aClass gtSafeIconNamed: anIconName ] ].

	aModel items: aCollection icon: anIconBuilder.
	aModel selectFirstItem.
	aModel label: 'Classes'.
	
	self
		assert: aModel selectedItem
		equals: (GtFilterModelPluggableItem new
				object: Array;
				icon: anIconBuilder).
	self assert: aModel selectedItem icon isNotNil.
	self assert: aModel selectedItem label equals: 'Array'.

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

{ #category : #examples }
GtFilterModelExamples >> toggleModelWithIcons [
	<gtExample>
	| aModel |
	aModel := GtFilterToggleModel new.
	aModel label: 'Origin'.
	aModel
		items: {GtFilterModelTraitOriginItem new.
				GtFilterModelClassOriginItem new}.
	aModel selectFirstItem.

	^ aModel
]
