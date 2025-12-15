Class {
	#name : #GtFilterMethodsCoderAvailableFiltersBuilder,
	#superclass : #Object,
	#instVars : [
		'coders'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #building }
GtFilterMethodsCoderAvailableFiltersBuilder >> availableFilters [
	<return: #Collection of: #GtFilterModel>
	| availableFilters |
	availableFilters := SortedCollection sortBlock: [ :a :b | a order < b order ].

	coders ifNil: [ ^ #() ].

	GtSearchMethodsFilter withAllSubclassesDo: [ :eachClass | 
		eachClass filterDescriptors2For: coders into: availableFilters ].
	
	^ availableFilters
]

{ #category : #accessing }
GtFilterMethodsCoderAvailableFiltersBuilder >> coders [
	<return: #GtPharoStreamingMethodsCoder>
	^ coders
]

{ #category : #accessing }
GtFilterMethodsCoderAvailableFiltersBuilder >> coders: aMethodsCoder [
	coders := aMethodsCoder
]
