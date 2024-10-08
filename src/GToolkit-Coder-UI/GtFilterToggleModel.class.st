Class {
	#name : #GtFilterToggleModel,
	#superclass : #GtFilterModel,
	#instVars : [
		'items',
		'selectedItem',
		'itemsBuilder'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterToggleModel >> filterViewModelClass [
	<return: #'GtFilterViewModel class'>
	^ GtFilterToggleViewModel
]

{ #category : #initialization }
GtFilterToggleModel >> initialize [
	super initialize.
	itemsBuilder := GtFilterModelEmptyItemsBuilder default.
]

{ #category : #accessing }
GtFilterToggleModel >> items [
	<return: #Collection of: #GtFilterModelItem>
	^ itemsBuilder create
]

{ #category : #accessing }
GtFilterToggleModel >> items: anObject [
	self itemsBuilder: anObject
]

{ #category : #accessing }
GtFilterToggleModel >> itemsBuilder [
	<return: #GtFilterModelItemsBuilder>
	^ itemsBuilder
]

{ #category : #accessing }
GtFilterToggleModel >> itemsBuilder: anObject [
	| aNewItemsBuilder |
	aNewItemsBuilder := anObject asFilterModelItemsBuilder.
	self itemsBuilder = aNewItemsBuilder ifTrue: [ ^ self ].
	itemsBuilder := aNewItemsBuilder.
	aNewItemsBuilder filterModel: self.

	self notifyItemsChanged
]

{ #category : #'private - notifying' }
GtFilterToggleModel >> notifyItemsChanged [
	self
		announce: (GtFilterModelItemsChanged new
				model: self;
				itemsBuilder: self itemsBuilder)
]

{ #category : #'private - notifying' }
GtFilterToggleModel >> notifySelectedItemChanged [
	self
		announce: (GtFilterModelSelectedItemChanged new
				model: self;
				selectedItem: self selectedItem)
]

{ #category : #initialization }
GtFilterToggleModel >> selectFirstItem [
	self itemsBuilder firstItemDo: [ :anItem | self selectedItem: anItem ]
]

{ #category : #initialization }
GtFilterToggleModel >> selectLastItem [
	self itemsBuilder lastItemDo: [ :anItem | self selectedItem: anItem ]
]

{ #category : #accessing }
GtFilterToggleModel >> selectedItem [
	^ selectedItem ifNil: [ selectedItem := GtFilterModelNoItem default ]
]

{ #category : #accessing }
GtFilterToggleModel >> selectedItem: anItem [
	| aNewItem |
	aNewItem := anItem asFilterModelItem.
	self selectedItem = aNewItem ifTrue: [ ^ self ].

	selectedItem := aNewItem.
	self notifySelectedItemChanged
]

{ #category : #accessing }
GtFilterToggleModel >> selectedValue [
	"Return a filter value, e.g., selected item, input text."

	^ self selectedItem
]
