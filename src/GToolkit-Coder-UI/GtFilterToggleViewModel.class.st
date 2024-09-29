Class {
	#name : #GtFilterToggleViewModel,
	#superclass : #GtFilterViewModel,
	#category : #'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
GtFilterToggleViewModel >> filterElementClass [
	<return: #'GtFilterSettingsElement class'>
	^ GtFilterToggleSettingsElement
]

{ #category : #accessing }
GtFilterToggleViewModel >> items [
	^ self filterModel items
]

{ #category : #accessing }
GtFilterToggleViewModel >> items: aCollection [
	self filterModel items: aCollection
]

{ #category : #accessing }
GtFilterToggleViewModel >> itemsCount [
	^ self filterModel items size
]

{ #category : #'event handling' }
GtFilterToggleViewModel >> onItemsChanged: anAnnouncement [
	self
		announce: (GtFilterViewModelItemsChanged new
				viewModel: self;
				items: anAnnouncement items)
]

{ #category : #'event handling' }
GtFilterToggleViewModel >> onSelectedItemChanged: anAnnouncement [
	self
		announce: (GtFilterViewModelSelectedItemChanged new
				viewModel: self;
				selectedItem: anAnnouncement selectedItem)
]

{ #category : #accessing }
GtFilterToggleViewModel >> selectedItem [
	^ self filterModel selectedItem
]

{ #category : #accessing }
GtFilterToggleViewModel >> selectedItem: anItem [
	self filterModel selectedItem: anItem
]

{ #category : #'api - filter model' }
GtFilterToggleViewModel >> subscribeToFilterModel [
	super subscribeToFilterModel.
	self filterModel weak
		when: GtFilterModelItemsChanged
			send: #onItemsChanged:
			to: self;
		when: GtFilterModelSelectedItemChanged
			send: #onSelectedItemChanged:
			to: self
]
