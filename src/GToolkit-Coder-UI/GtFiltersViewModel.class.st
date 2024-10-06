Class {
	#name : #GtFiltersViewModel,
	#superclass : #Object,
	#traits : 'TGtWithFiltersModel + TGtAnnouncer',
	#classTraits : 'TGtWithFiltersModel classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'filterViewModels'
	],
	#category : #'GToolkit-Coder-UI-Filters - View Models'
}

{ #category : #'add / remove' }
GtFiltersViewModel >> addFilterModel: aFilterModel [
	self hasFiltersModel ifFalse: [ ^ self ].

	^ self filtersModel addFilterModel: aFilterModel
]

{ #category : #announcer }
GtFiltersViewModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #converting }
GtFiltersViewModel >> asFiltersElement [
	^ self filtersElementClass new filtersViewModel: self
]

{ #category : #accessing }
GtFiltersViewModel >> availableFilters [
	"Return a collection of available filters"

	<return: #Collection of: #GtFilterModel>
	^ self filtersModel availableFilters
]

{ #category : #private }
GtFiltersViewModel >> createFilterViewModelFor: aFilterModel [
	^ aFilterModel asFilterViewModel
]

{ #category : #private }
GtFiltersViewModel >> ensureFilterViewModelFor: aFilterModel [
	^ filterViewModels
		at: aFilterModel
		ifPresent: [ :aFilterViewModel | aFilterViewModel ]
		ifAbsentPut: [ self createFilterViewModelFor: aFilterModel ]
]

{ #category : #accessing }
GtFiltersViewModel >> filtersElementClass [
	^ self subclassResponsibility
]

{ #category : #initialization }
GtFiltersViewModel >> initialize [
	super initialize.
	filterViewModels := IdentityDictionary new
]

{ #category : #'add / remove' }
GtFiltersViewModel >> removeFilterViewModel: aFilterViewModel [
	aFilterViewModel hasFilterModel ifFalse: [ ^ self ].
	filterViewModels removeKey: aFilterViewModel filterModel ifAbsent: [ "ignore" ].
	
	self hasFiltersModel ifFalse: [ ^ self ].
	self filtersModel removeFilterModel: aFilterViewModel filterModel
]
