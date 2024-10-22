Class {
	#name : #GtFilterSelectableItemViewModel,
	#superclass : #GtFilterViewModel,
	#category : #'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
GtFilterSelectableItemViewModel >> items [
	^ self filterModel items
]

{ #category : #accessing }
GtFilterSelectableItemViewModel >> items: aCollection [
	self filterModel items: aCollection
]

{ #category : #accessing }
GtFilterSelectableItemViewModel >> itemsCount [
	^ self filterModel items size
]

{ #category : #accessing }
GtFilterSelectableItemViewModel >> name [
	^ self filterModel name
]

{ #category : #'event handling' }
GtFilterSelectableItemViewModel >> onItemsChanged: anAnnouncement [
	self
		announce: (GtFilterViewModelItemsChanged new
				viewModel: self;
				itemsBuilder: anAnnouncement itemsBuilder)
]

{ #category : #'event handling' }
GtFilterSelectableItemViewModel >> onSelectedItemChanged: anAnnouncement [
	self
		announce: (GtFilterViewModelSelectedItemChanged new
				viewModel: self;
				selectedItem: anAnnouncement selectedItem)
]

{ #category : #accessing }
GtFilterSelectableItemViewModel >> selectedItem [
	^ self filterModel selectedItem
]

{ #category : #accessing }
GtFilterSelectableItemViewModel >> selectedItem: anItem [
	self filterModel selectedItem: anItem
]

{ #category : #'api - filter model' }
GtFilterSelectableItemViewModel >> subscribeToFilterModel [
	super subscribeToFilterModel.
	self filterModel weak
		when: GtFilterModelItemsChanged
			send: #onItemsChanged:
			to: self;
		when: GtFilterModelSelectedItemChanged
			send: #onSelectedItemChanged:
			to: self
]
