Class {
	#name : #GtFilterShortListModel,
	#superclass : #GtFilterModel,
	#instVars : [
		'items',
		'selectedItem'
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
	items := #()
]

{ #category : #accessing }
GtFilterShortListModel >> items [
	<return: #OrderedCollection>
	^ items
]

{ #category : #accessing }
GtFilterShortListModel >> items: aCollection [
	| aNewCollection |
	aNewCollection := aCollection collect: #asFilterShortListModelItem.
	self items = aNewCollection ifTrue: [ ^ self ].

	items := aNewCollection.
	self notifyItemsChanged.
]

{ #category : #accessing }
GtFilterShortListModel >> notifyItemsChanged [
	self
		announce: (GtFilterShortListModelItemsChanged new
				model: self;
				items: self items)
]

{ #category : #accessing }
GtFilterShortListModel >> notifySelectedItemChanged [
	self
		announce: (GtFilterShortListModelSelectedItemChanged new
				model: self;
				selectedItem: self selectedItem)
]

{ #category : #initialization }
GtFilterShortListModel >> selectFirstItem [
	self items ifEmpty: [ ^ self ].
	self selectedItem: self items first
]

{ #category : #initialization }
GtFilterShortListModel >> selectLastItem [
	self items ifEmpty: [ ^ self ].
	self selectedItem: self items last
]

{ #category : #accessing }
GtFilterShortListModel >> selectedItem [
	^ selectedItem ifNil: [ selectedItem := GtFilterShortListModelNoItem default ]
]

{ #category : #accessing }
GtFilterShortListModel >> selectedItem: anItem [
	| aNewItem |
	aNewItem := anItem asFilterShortListModelItem.
	self selectedItem = aNewItem ifTrue: [ ^ self ].

	selectedItem := aNewItem.
	self notifySelectedItemChanged
]

{ #category : #accessing }
GtFilterShortListModel >> selectedValue [
	"Return a filter value, e.g., selected item, input text."

	^ self selectedItem
]
