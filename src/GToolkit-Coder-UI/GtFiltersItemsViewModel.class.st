Class {
	#name : #GtFiltersItemsViewModel,
	#superclass : #GtFiltersViewModel,
	#category : #'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #accessing }
GtFiltersItemsViewModel >> filtersElementClass [
	^ GtFilterItemsElement
]

{ #category : #accessing }
GtFiltersItemsViewModel >> items [
	<return: #Collection of: #GtFilterViewModel>
	^ self filtersModel items collect: [ :eachFilterModel | 
		self ensureFilterViewModelFor: eachFilterModel ]
]

{ #category : #'event handling' }
GtFiltersItemsViewModel >> onItemsChanged: anAnnouncement [
	self removeOldFilterViewModelsFor: anAnnouncement items.
	self
		announce: (GtFiltersViewModelItemsChanged new
				viewModel: self;
				items: self items)
]

{ #category : #'event handling' }
GtFiltersItemsViewModel >> removeOldFilterViewModelsFor: aCollectionOfFilterModels [
	"Remove filter view models of removed filter models.
	New filter view models are added on #items call."
	
	| toRemove |
	toRemove := filterViewModels keys reject: [ :each | 
		aCollectionOfFilterModels includes: each ].
	toRemove do: [ :eachKey | 
		filterViewModels removeKey: eachKey ifAbsent: [ "ignore" ] ]
]

{ #category : #'api - filter model' }
GtFiltersItemsViewModel >> subscribeToFiltersModel [
	self filtersModel weak
		when: GtFiltersModelItemsChanged
		send: #onItemsChanged:
		to: self
]

{ #category : #'api - filter model' }
GtFiltersItemsViewModel >> unsubscribeFromFiltersModel [
	self filtersModel unsubscribe: self
]
