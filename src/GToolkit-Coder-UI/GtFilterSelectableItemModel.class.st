Class {
	#name : #GtFilterSelectableItemModel,
	#superclass : #GtFilterModel,
	#instVars : [
		'items',
		'selectedItem',
		'itemsBuilder'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #testing }
GtFilterSelectableItemModel class >> isAbstract [
	^ self name = #GtFilterSelectableItemModel
]

{ #category : #testing }
GtFilterSelectableItemModel >> changesFilteredResult [
	"Indicates whether it changes a result of filtered items, e.g., list of method coders."

	<return: #Boolean>
	^ self selectedItem ifSome: [ true ] ifNone: [ false ]
]

{ #category : #initialization }
GtFilterSelectableItemModel >> initialize [
	super initialize.
	itemsBuilder := GtFilterModelEmptyItemsBuilder default.
]

{ #category : #accessing }
GtFilterSelectableItemModel >> items [
	<return: #Collection of: #GtFilterModelItem>
	^ itemsBuilder create
]

{ #category : #accessing }
GtFilterSelectableItemModel >> items: anObject [
	self itemsBuilder: anObject
]

{ #category : #accessing }
GtFilterSelectableItemModel >> items: anObject icon: anIconStencilBuilder [
	| aNewItemsBuilder aPluggableItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	aPluggableItemsBuilder := GtFilterModelPluggableItemsBuilder new
			itemsBuilder: aNewItemsBuilder;
			iconStencilBuilder: anIconStencilBuilder.
	self itemsBuilder: aPluggableItemsBuilder
]

{ #category : #accessing }
GtFilterSelectableItemModel >> items: anObject icon: anIconStencilBuilder label: aLabelStencilBuilder [
	| aNewItemsBuilder aPluggableItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	aPluggableItemsBuilder := GtFilterModelPluggableItemsBuilder new
			itemsBuilder: aNewItemsBuilder;
			iconStencilBuilder: anIconStencilBuilder;
			labelStencilBuilder: aLabelStencilBuilder.
	self itemsBuilder: aPluggableItemsBuilder
]

{ #category : #accessing }
GtFilterSelectableItemModel >> items: anObject label: aLabelStencilBuilder [
	| aNewItemsBuilder aPluggableItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	aPluggableItemsBuilder := GtFilterModelPluggableItemsBuilder new
			itemsBuilder: aNewItemsBuilder;
			labelStencilBuilder: aLabelStencilBuilder.
	self itemsBuilder: aPluggableItemsBuilder
]

{ #category : #accessing }
GtFilterSelectableItemModel >> itemsBuilder [
	<return: #GtFilterModelItemsBuilder>
	^ itemsBuilder
]

{ #category : #accessing }
GtFilterSelectableItemModel >> itemsBuilder: anObject [
	| aNewItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	self itemsBuilder = aNewItemsBuilder ifTrue: [ ^ self ].
	itemsBuilder := aNewItemsBuilder.
	aNewItemsBuilder filterModel: self.

	self notifyItemsChanged
]

{ #category : #'private - notifying' }
GtFilterSelectableItemModel >> notifyItemsChanged [
	self
		announce: (GtFilterModelItemsChanged new
				model: self;
				itemsBuilder: self itemsBuilder)
]

{ #category : #'private - notifying' }
GtFilterSelectableItemModel >> notifySelectedItemChanged [
	self
		announce: (GtFilterModelSelectedItemChanged new
				model: self;
				selectedItem: self selectedItem)
]

{ #category : #initialization }
GtFilterSelectableItemModel >> selectFirstItem [
	self itemsBuilder firstItemDo: [ :anItem | self selectedItem: anItem ]
]

{ #category : #initialization }
GtFilterSelectableItemModel >> selectLastItem [
	self itemsBuilder lastItemDo: [ :anItem | self selectedItem: anItem ]
]

{ #category : #accessing }
GtFilterSelectableItemModel >> selectedItem [
	^ selectedItem ifNil: [ selectedItem := GtFilterModelNoItem default ]
]

{ #category : #accessing }
GtFilterSelectableItemModel >> selectedItem: anItem [
	| aNewItem |
	aNewItem := anItem asFilterModelItem.
	self selectedItem = aNewItem ifTrue: [ ^ self ].

	selectedItem := aNewItem.
	self notifySelectedItemChanged
]

{ #category : #accessing }
GtFilterSelectableItemModel >> selectedValue [
	"Return a filter value, e.g., selected item, input text."

	^ self selectedItem
]
