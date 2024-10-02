Class {
	#name : #GtFilterItemsModel,
	#superclass : #GtFiltersModel,
	#instVars : [
		'items'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #'add / remove' }
GtFilterItemsModel >> addFilterModel: aFilterModel [
	self items: (self items copyWith: aFilterModel)
]

{ #category : #accessing }
GtFilterItemsModel >> filtersViewModelClass [
	<return: #'GtFiltersViewModel class'>
	^ GtFiltersItemsViewModel
]

{ #category : #'gt - extensions' }
GtFilterItemsModel >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Items';
		items: [ self items ifNil: [ #() ] ];
		column: 'Index'
			text: [ :_ :anIndex | anIndex ]
			width: 40;
		column: 'Name' text: #yourself;
		column: 'Selected value' text: #selectedValue;
		actionUpdateButton
]

{ #category : #initialization }
GtFilterItemsModel >> initialize [
	super initialize.
	items := Array empty
]

{ #category : #accessing }
GtFilterItemsModel >> items [
	<return: #Collection of: #GtFilterModel>
	^ items
]

{ #category : #accessing }
GtFilterItemsModel >> items: aCollection [
	self items = aCollection ifTrue: [ ^ self ].

	items := aCollection.
	self subscribeToItems.
	self notifyItemsChanged.
	self notifyFiltersUpdated.
]

{ #category : #'private - notifying' }
GtFilterItemsModel >> notifyFiltersUpdated [
	self announce: (GtFiltersModelUpdated new model: self)
]

{ #category : #'private - notifying' }
GtFilterItemsModel >> notifyItemsChanged [
	self
		announce: (GtFiltersModelItemsChanged new
				model: self;
				items: self items)
]

{ #category : #'event handling' }
GtFilterItemsModel >> onFilterModelAnnouncement: anAnnouncement [
	anAnnouncement changesFilteredResult ifFalse: [ ^ self ].
	self notifyFiltersUpdated
]

{ #category : #'add / remove' }
GtFilterItemsModel >> removeFilterModel: aFilterModel [
	self items: (self items copyWithout: aFilterModel)
]

{ #category : #private }
GtFilterItemsModel >> subscribeToItem: aFilterModel [
	(aFilterModel hasSubscriber: self) ifTrue: [ ^ self ].

	aFilterModel weak
		when: GtFilterModelAnnouncement
			send: #onFilterModelAnnouncement:
			to: self
]

{ #category : #private }
GtFilterItemsModel >> subscribeToItems [
	self items do: [ :eachItem |
		self subscribeToItem: eachItem ]
]
