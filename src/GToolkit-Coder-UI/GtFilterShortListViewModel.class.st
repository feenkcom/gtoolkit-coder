Class {
	#name : #GtFilterShortListViewModel,
	#superclass : #GtFilterViewModel,
	#category : #'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
GtFilterShortListViewModel >> filterElementClass [
	^ GtFilterShortListSettingsElement
]

{ #category : #accessing }
GtFilterShortListViewModel >> items [
	^ self filterModel items
]

{ #category : #accessing }
GtFilterShortListViewModel >> items: aCollection [
	self filterModel items: aCollection
]

{ #category : #accessing }
GtFilterShortListViewModel >> itemsCount [
	^ self filterModel items size
]

{ #category : #accessing }
GtFilterShortListViewModel >> itemsWithoutSelection [
	| aSelectedItem |
	aSelectedItem := self selectedItem.
	^ self filterModel items reject: [ :each | aSelectedItem = each ]
]

{ #category : #'api - filter model' }
GtFilterShortListViewModel >> onItemsChanged: anAnnouncement [
	self
		announce: (GtFilterShortListViewModelItemsChanged new
				viewModel: self;
				items: anAnnouncement items)
]

{ #category : #'api - filter model' }
GtFilterShortListViewModel >> onSelectedItemChanged: anAnnouncement [
	self
		announce: (GtFilterShortListViewModelSelectedItemChanged new
				viewModel: self;
				selectedItem: anAnnouncement selectedItem)
]

{ #category : #accessing }
GtFilterShortListViewModel >> selectedItem [
	^ self filterModel selectedItem
]

{ #category : #accessing }
GtFilterShortListViewModel >> selectedItem: anItem [
	self filterModel selectedItem: anItem
]

{ #category : #'api - filter model' }
GtFilterShortListViewModel >> subscribeToFilterModel [
	super subscribeToFilterModel.
	self filterModel weak
		when: GtFilterShortListModelItemsChanged
			send: #onItemsChanged:
			to: self;
		when: GtFilterShortListModelSelectedItemChanged
			send: #onSelectedItemChanged:
			to: self
]
