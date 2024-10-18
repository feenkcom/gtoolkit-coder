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
	aModel name: 'Trait methods'.
	self assert: aModel isSwitchedOn.

	^ aModel
]

{ #category : #examples }
GtFilterModelExamples >> invariableModel [
	<gtExample>
	| aModel |
	aModel := GtFilterInvariableModel new.
	aModel name: 'Stable tests'.

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
GtFilterModelExamples >> itemsModelWithAddingShortListModelWithSelectedValue [
	<gtExample>
	| aFiltersModel aFilterModel someAnnouncements |
	someAnnouncements := OrderedCollection new.
	aFiltersModel := GtFilterItemsModel new.
	aFiltersModel weak
		when: GtFiltersModelUpdated
		send: #add:
		to: someAnnouncements.

	aFilterModel := self shortListModel.
	self assert: (aFilterModel selectedItem ifSome: [ true ] ifNone: [ false ]).
	
	aFiltersModel addFilterModel: aFilterModel.

	self assert: aFiltersModel items size equals: 1.
	self assert: someAnnouncements size equals: 1.

	^ aFiltersModel
]

{ #category : #examples }
GtFilterModelExamples >> itemsModelWithAddingShortListModelWithoutSelectedValue [
	<gtExample>
	| aFiltersModel aFilterModel someAnnouncements |
	someAnnouncements := OrderedCollection new.
	aFiltersModel := GtFilterItemsModel new.
	aFiltersModel weak
		when: GtFiltersModelUpdated
		send: #add:
		to: someAnnouncements.

	aFilterModel := self shortListModel.
	aFilterModel selectedItem: GtFilterModelNoItem default.
	self assert: (aFilterModel selectedItem ifSome: [ false ] ifNone: [ true ]).
	
	aFiltersModel addFilterModel: aFilterModel.

	self assert: aFiltersModel items size equals: 1.
	self assert: someAnnouncements size equals: 0.

	^ aFiltersModel
]

{ #category : #examples }
GtFilterModelExamples >> itemsModelWithAddingTextModelWithEmptyText [
	<gtExample>
	| aFiltersModel aFilterModel someAnnouncements |
	someAnnouncements := OrderedCollection new.
	aFiltersModel := GtFilterItemsModel new.
	aFiltersModel weak
		when: GtFiltersModelUpdated
		send: #add:
		to: someAnnouncements.

	aFilterModel := self textModel.
	aFilterModel text: ''.
	self assert: aFilterModel text isEmpty.
	
	aFiltersModel addFilterModel: aFilterModel.

	self assert: aFiltersModel items size equals: 1.
	self assert: someAnnouncements size equals: 0.

	^ aFiltersModel
]

{ #category : #examples }
GtFilterModelExamples >> itemsModelWithAddingTextModelWithNonEmptyText [
	<gtExample>
	| aFiltersModel aFilterModel someAnnouncements |
	someAnnouncements := OrderedCollection new.
	aFiltersModel := GtFilterItemsModel new.
	aFiltersModel weak
		when: GtFiltersModelUpdated
		send: #add:
		to: someAnnouncements.

	aFilterModel := self textModel.
	self assert: aFilterModel text isEmpty not.
	
	aFiltersModel addFilterModel: aFilterModel.

	self assert: aFiltersModel items size equals: 1.
	self assert: someAnnouncements size equals: 1.

	^ aFiltersModel
]

{ #category : #examples }
GtFilterModelExamples >> itemsModelWithAddingToggleModelWithSelectedValue [
	<gtExample>
	| aFiltersModel aFilterModel someAnnouncements |
	someAnnouncements := OrderedCollection new.
	aFiltersModel := GtFilterItemsModel new.
	aFiltersModel weak
		when: GtFiltersModelUpdated
		send: #add:
		to: someAnnouncements.

	aFilterModel := self toggleModel.
	self assert: (aFilterModel selectedItem ifSome: [ true ] ifNone: [ false ]).
	
	aFiltersModel addFilterModel: aFilterModel.

	self assert: aFiltersModel items size equals: 1.
	self assert: someAnnouncements size equals: 1.

	^ aFiltersModel
]

{ #category : #examples }
GtFilterModelExamples >> itemsModelWithAddingToggleModelWithoutSelectedValue [
	<gtExample>
	| aFiltersModel aFilterModel someAnnouncements |
	someAnnouncements := OrderedCollection new.
	aFiltersModel := GtFilterItemsModel new.
	aFiltersModel weak
		when: GtFiltersModelUpdated
		send: #add:
		to: someAnnouncements.

	aFilterModel := self toggleModel.
	aFilterModel selectedItem: GtFilterModelNoItem default.
	self assert: (aFilterModel selectedItem ifSome: [ false ] ifNone: [ true ]).
	
	aFiltersModel addFilterModel: aFilterModel.

	self assert: aFiltersModel items size equals: 1.
	self assert: someAnnouncements size equals: 0.

	^ aFiltersModel
]

{ #category : #examples }
GtFilterModelExamples >> itemsModelWithRemovingShortListModelWithSelectedValue [
	<gtExample>
	| aFiltersModel aFilterModel someAnnouncements |
	someAnnouncements := OrderedCollection new.
	aFiltersModel := self itemsModelWithAddingShortListModelWithSelectedValue.
	aFiltersModel weak
		when: GtFiltersModelUpdated
		send: #add:
		to: someAnnouncements.

	aFilterModel := aFiltersModel items first.
	self assert: (aFilterModel selectedItem ifSome: [ true ] ifNone: [ false ]).
	
	aFiltersModel removeFilterModel: aFilterModel.

	self assert: aFiltersModel items size equals: 0.
	self assert: someAnnouncements size equals: 1.

	^ aFiltersModel
]

{ #category : #examples }
GtFilterModelExamples >> itemsModelWithRemovingShortListModelWithoutSelectedValue [
	<gtExample>
	| aFiltersModel aFilterModel someAnnouncements |
	someAnnouncements := OrderedCollection new.
	aFiltersModel := self itemsModelWithAddingShortListModelWithoutSelectedValue.
	aFiltersModel weak
		when: GtFiltersModelUpdated
		send: #add:
		to: someAnnouncements.

	aFilterModel := aFiltersModel items first.
	self assert: (aFilterModel selectedItem ifSome: [ false ] ifNone: [ true ]).
	
	aFiltersModel removeFilterModel: aFilterModel.

	self assert: aFiltersModel items size equals: 0.
	self assert: someAnnouncements size equals: 0.

	^ aFiltersModel
]

{ #category : #examples }
GtFilterModelExamples >> itemsModelWithRemovingTextModelWithEmptyText [
	<gtExample>
	| aFiltersModel aFilterModel someAnnouncements |
	someAnnouncements := OrderedCollection new.
	aFiltersModel := self itemsModelWithAddingTextModelWithEmptyText.
	aFiltersModel weak
		when: GtFiltersModelUpdated
		send: #add:
		to: someAnnouncements.

	aFilterModel := aFiltersModel items first.
	self assert: aFilterModel text isEmpty.
	
	aFiltersModel removeFilterModel: aFilterModel.

	self assert: aFiltersModel items size equals: 0.
	self assert: someAnnouncements size equals: 0.

	^ aFiltersModel
]

{ #category : #examples }
GtFilterModelExamples >> itemsModelWithRemovingTextModelWithNonEmptyText [
	<gtExample>
	| aFiltersModel aFilterModel someAnnouncements |
	someAnnouncements := OrderedCollection new.
	aFiltersModel := self itemsModelWithAddingTextModelWithNonEmptyText.
	aFiltersModel weak
		when: GtFiltersModelUpdated
		send: #add:
		to: someAnnouncements.

	aFilterModel := aFiltersModel items first.
	self assert: aFilterModel text isEmpty not.
	
	aFiltersModel removeFilterModel: aFilterModel.

	self assert: aFiltersModel items size equals: 0.
	self assert: someAnnouncements size equals: 1.

	^ aFiltersModel
]

{ #category : #examples }
GtFilterModelExamples >> itemsModelWithRemovingToggleModelWithSelectedValue [
	<gtExample>
	| aFiltersModel aFilterModel someAnnouncements |
	someAnnouncements := OrderedCollection new.
	aFiltersModel := self itemsModelWithAddingToggleModelWithSelectedValue.
	aFiltersModel weak
		when: GtFiltersModelUpdated
		send: #add:
		to: someAnnouncements.

	aFilterModel := aFiltersModel items first.
	self assert: (aFilterModel selectedItem ifSome: [ true ] ifNone: [ false ]).
	
	aFiltersModel removeFilterModel: aFilterModel.

	self assert: aFiltersModel items size equals: 0.
	self assert: someAnnouncements size equals: 1.

	^ aFiltersModel
]

{ #category : #examples }
GtFilterModelExamples >> itemsModelWithRemovingToggleModelWithoutSelectedValue [
	<gtExample>
	| aFiltersModel aFilterModel someAnnouncements |
	someAnnouncements := OrderedCollection new.
	aFiltersModel := self itemsModelWithAddingToggleModelWithoutSelectedValue.
	aFiltersModel weak
		when: GtFiltersModelUpdated
		send: #add:
		to: someAnnouncements.

	aFilterModel := aFiltersModel items first.
	self assert: (aFilterModel selectedItem ifSome: [ false ] ifNone: [ true ]).
	
	aFiltersModel removeFilterModel: aFilterModel.

	self assert: aFiltersModel items size equals: 0.
	self assert: someAnnouncements size equals: 0.

	^ aFiltersModel
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
	aModel name: 'Side'.
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
	aModel name: 'Methods up to'.
	self assert: (aModel text equals: 'Object' asRopedText).

	^ aModel
]

{ #category : #examples }
GtFilterModelExamples >> toggleModel [
	<gtExample>
	| aModel |
	aModel := GtFilterToggleModel new.
	aModel name: 'Side'.
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
