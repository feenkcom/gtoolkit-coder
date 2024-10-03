Class {
	#name : #GtFilterShortListModel,
	#superclass : #GtFilterModel,
	#instVars : [
		'selectedItem',
		'itemsBuilder'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

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
