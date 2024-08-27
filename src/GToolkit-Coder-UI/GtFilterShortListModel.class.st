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

{ #category : #accessing }
GtFilterShortListModel >> selectedItem [
	^ selectedItem
]

{ #category : #accessing }
GtFilterShortListModel >> selectedItem: anItem [
	| aNewItem |
	aNewItem := anItem asFilterShortListModelItem.
	self selectedItem = aNewItem ifTrue: [ ^ self ].

	selectedItem := aNewItem.
	self notifySelectedItemChanged
]
