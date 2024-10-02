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
	<return: #Collection of: #GtFilterModelItem>
	^ self filterModel items
]

{ #category : #accessing }
GtFilterShortListViewModel >> items: aCollection [
	self filterModel items: aCollection
]

{ #category : #accessing }
GtFilterShortListViewModel >> itemsCount [
	<return: #TAsyncStream of: #Integer>
	^ self filterModel items size
]

{ #category : #accessing }
GtFilterShortListViewModel >> itemsWithoutSelection [
	<return: #Collection of: #GtFilterModelItem>
	^ self filterModel items select: [ :each | self selectedItem ~= each ]
]

{ #category : #'event handling' }
GtFilterShortListViewModel >> onItemsChanged: anAnnouncement [
	self
		announce: (GtFilterViewModelItemsChanged new
				viewModel: self;
				itemsBuilder: anAnnouncement itemsBuilder)
]

{ #category : #'api - filter model' }
GtFilterShortListViewModel >> onSelectedItemChanged: anAnnouncement [
	self
		announce: (GtFilterViewModelSelectedItemChanged new
				viewModel: self;
				selectedItem: anAnnouncement selectedItem)
]

{ #category : #accessing }
GtFilterShortListViewModel >> selectedItem [
	<return: #GtFilterModelItem>
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
		when: GtFilterModelItemsChanged
			send: #onItemsChanged:
			to: self;
		when: GtFilterModelSelectedItemChanged
			send: #onSelectedItemChanged:
			to: self
]
