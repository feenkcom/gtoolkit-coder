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

{ #category : #'api - filter model' }
GtFiltersItemsViewModel >> onItemAdded: anAnnouncement [
	| aViewModel |
	aViewModel := self ensureFilterViewModelFor: anAnnouncement item.
	self
		announce: (GtFiltersViewModelItemAdded new
				viewModel: self;
				item: aViewModel)
]

{ #category : #'api - filter model' }
GtFiltersItemsViewModel >> onItemRemoved: anAnnouncement [
	| aViewModel |
	aViewModel := self removeOldFilterViewModelFor: anAnnouncement item.
	aViewModel ifNil: [ ^ self ].
	self
		announce: (GtFiltersViewModelItemRemoved new
				viewModel: self;
				item: aViewModel)
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
GtFiltersItemsViewModel >> removeOldFilterViewModelFor: aFilterModel [
	^ filterViewModels removeKey: aFilterModel ifAbsent: [ nil ]
]

{ #category : #'event handling' }
GtFiltersItemsViewModel >> removeOldFilterViewModelsFor: aCollectionOfFilterModels [
	"Remove filter view models of removed filter models.
	New filter view models are added on #items call."

	| toRemove |
	toRemove := filterViewModels keys
			reject: [ :each | aCollectionOfFilterModels identityIncludes: each ].
	toRemove do: [ :eachFilterModel | self removeOldFilterViewModelFor: eachFilterModel ]
]

{ #category : #'api - filter model' }
GtFiltersItemsViewModel >> subscribeToFiltersModel [
	self filtersModel weak
		when: GtFiltersModelItemsChanged
			send: #onItemsChanged:
			to: self;
		when: GtFiltersModelItemAdded
			send: #onItemAdded:
			to: self;
		when: GtFiltersModelItemRemoved
			send: #onItemRemoved:
			to: self
]

{ #category : #'api - filter model' }
GtFiltersItemsViewModel >> unsubscribeFromFiltersModel [
	self filtersModel unsubscribe: self
]
