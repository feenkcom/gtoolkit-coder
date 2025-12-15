Class {
	#name : #GtFiltersModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'availableFiltersBuilder'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #'add / remove' }
GtFiltersModel >> addFilterModel: aFilterModel [
	self subclassResponsibility
]

{ #category : #announcer }
GtFiltersModel >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #converting }
GtFiltersModel >> asFiltersElement [
	<return: #BlElement>
	^ self asFiltersViewModel asFiltersElement
]

{ #category : #converting }
GtFiltersModel >> asFiltersViewModel [
	<return: #GtFilterViewModel>
	^ self filtersViewModelClass new filtersModel: self
]

{ #category : #accessing }
GtFiltersModel >> availableFilters [
	"Return a collection of available filters"

	<return: #Collection of: #GtFilterModel>
	^ availableFiltersBuilder ifNotNil: #availableFilters ifNil: [ #() ]
]

{ #category : #accessing }
GtFiltersModel >> availableFiltersBuilder [
	^ availableFiltersBuilder
]

{ #category : #accessing }
GtFiltersModel >> availableFiltersBuilder: aBuilder [
	availableFiltersBuilder := aBuilder
]

{ #category : #accessing }
GtFiltersModel >> filtersViewModelClass [
	<return: #'GtFiltersViewModel class'>
	^ self subclassResponsibility
]

{ #category : #'gt - extensions' }
GtFiltersModel >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		stencil: [ self asFiltersElement margin: (BlInsets all: 10) ]
]
