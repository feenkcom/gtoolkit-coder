Class {
	#name : #GtFilterShortListModel,
	#superclass : #GtFilterModel,
	#instVars : [
		'selectedItem',
		'itemsBuilder'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #testing }
GtFilterShortListModel >> changesFilteredResult [
	"Indicates whether it changes a result of filtered items, e.g., list of method coders."

	<return: #Boolean>
	^ self selectedItem ifSome: [ true ] ifNone: [ false ]
]

{ #category : #accessing }
GtFilterShortListModel >> filterViewModelClass [
	^ GtFilterShortListViewModel
]

{ #category : #initialization }
GtFilterShortListModel >> initialize [
	super initialize.
	itemsBuilder := GtFilterModelEmptyItemsBuilder default.
]

{ #category : #accessing }
GtFilterShortListModel >> items [
	<return: #Collection of: #GtFilterModelItem>
	^ itemsBuilder create
]

{ #category : #accessing }
GtFilterShortListModel >> items: anObject [
	self itemsBuilder: anObject
]

{ #category : #accessing }
GtFilterShortListModel >> items: anObject icon: anIconStencilBuilder [
	| aNewItemsBuilder aPluggableItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	aPluggableItemsBuilder := GtFilterModelPluggableItemsBuilder new
			itemsBuilder: aNewItemsBuilder;
			iconStencilBuilder: anIconStencilBuilder.
	self itemsBuilder: aPluggableItemsBuilder
]

{ #category : #accessing }
GtFilterShortListModel >> items: anObject icon: anIconStencilBuilder label: aLabelStencilBuilder [
	| aNewItemsBuilder aPluggableItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	aPluggableItemsBuilder := GtFilterModelPluggableItemsBuilder new
			itemsBuilder: aNewItemsBuilder;
			iconStencilBuilder: anIconStencilBuilder;
			labelStencilBuilder: aLabelStencilBuilder.
	self itemsBuilder: aPluggableItemsBuilder
]

{ #category : #accessing }
GtFilterShortListModel >> items: anObject label: aLabelStencilBuilder [
	| aNewItemsBuilder aPluggableItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	aPluggableItemsBuilder := GtFilterModelPluggableItemsBuilder new
			itemsBuilder: aNewItemsBuilder;
			labelStencilBuilder: aLabelStencilBuilder.
	self itemsBuilder: aPluggableItemsBuilder
]

{ #category : #accessing }
GtFilterShortListModel >> itemsBuilder [
	<return: #GtFilterModelItemsBuilder>
	^ itemsBuilder
]

{ #category : #accessing }
GtFilterShortListModel >> itemsBuilder: anObject [
	| aNewItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	self itemsBuilder = aNewItemsBuilder ifTrue: [ ^ self ].
	itemsBuilder := aNewItemsBuilder.
	aNewItemsBuilder filterModel: self.

	self notifyItemsChanged
]

{ #category : #'private - notifying' }
GtFilterShortListModel >> notifyItemsChanged [
	self
		announce: (GtFilterModelItemsChanged new
				model: self;
				itemsBuilder: self itemsBuilder)
]

{ #category : #'private - notifying' }
GtFilterShortListModel >> notifySelectedItemChanged [
	self
		announce: (GtFilterModelSelectedItemChanged new
				model: self;
				selectedItem: self selectedItem)
]

{ #category : #initialization }
GtFilterShortListModel >> selectFirstItem [
	self itemsBuilder firstItemDo: [ :anItem | self selectedItem: anItem ]
]

{ #category : #initialization }
GtFilterShortListModel >> selectLastItem [
	self itemsBuilder lastItemDo: [ :anItem | self selectedItem: anItem ]
]

{ #category : #accessing }
GtFilterShortListModel >> selectedItem [
	^ selectedItem ifNil: [ selectedItem := GtFilterModelNoItem default ]
]

{ #category : #accessing }
GtFilterShortListModel >> selectedItem: anItem [
	| aNewItem |
	aNewItem := anItem asFilterModelItem.
	self selectedItem = aNewItem ifTrue: [ ^ self ].

	selectedItem := aNewItem.
	self notifySelectedItemChanged
]

{ #category : #accessing }
GtFilterShortListModel >> selectedValue [
	"Return a filter value, e.g., selected item, input text."

	^ self selectedItem
]
