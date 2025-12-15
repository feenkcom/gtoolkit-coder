Class {
	#name : #GtFilterSelectableItemViewModel,
	#superclass : #GtFilterViewModel,
	#traits : 'TGtFilterViewModelParameters',
	#classTraits : 'TGtFilterViewModelParameters classTrait',
	#category : 'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
GtFilterSelectableItemViewModel >> items: aCollection [
	self filterModel items: aCollection
]

{ #category : #accessing }
GtFilterSelectableItemViewModel >> itemsFuture [
	<return: #TAsyncFuture of: #Collection of: #GtFilterModelItem>
	^ self filterModel itemsFuture
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
