Class {
	#name : #GtFilterToggleModel,
	#superclass : #GtFilterModel,
	#instVars : [
		'items',
		'selectedItem'
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
	items := #()
]

{ #category : #accessing }
GtFilterToggleModel >> items [
	<return: #OrderedCollection>
	^ items
]

{ #category : #accessing }
GtFilterToggleModel >> items: aCollection [
	| aNewCollection |
	aNewCollection := aCollection collect: #asFilterModelItem.
	self items = aNewCollection ifTrue: [ ^ self ].

	items := aNewCollection.
	self notifyItemsChanged.
]

{ #category : #'private - notifying' }
GtFilterToggleModel >> notifyItemsChanged [
	self
		announce: (GtFilterModelItemsChanged new
				model: self;
				items: self items)
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
	self items ifEmpty: [ ^ self ].
	self selectedItem: self items first
]

{ #category : #initialization }
GtFilterToggleModel >> selectLastItem [
	self items ifEmpty: [ ^ self ].
	self selectedItem: self items last
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
