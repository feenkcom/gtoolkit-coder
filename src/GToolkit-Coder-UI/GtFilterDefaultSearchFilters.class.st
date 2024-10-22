Class {
	#name : #GtFilterDefaultSearchFilters,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'searchFilters'
	],
	#category : #'GToolkit-Coder-UI-Filters - Support'
}

{ #category : #'add / remove' }
GtFilterDefaultSearchFilters class >> addSearchFilter: aSearchFilter [
	self default addSearchFilter: aSearchFilter
]

{ #category : #'add / remove' }
GtFilterDefaultSearchFilters class >> addSearchFilters: aCollectionOfSearchFilters [
	self default addSearchFilters: aCollectionOfSearchFilters
]

{ #category : #accessing }
GtFilterDefaultSearchFilters class >> searchFilters [
	^ self default searchFilters
]

{ #category : #accessing }
GtFilterDefaultSearchFilters class >> searchFilters: aCollectionOfSearchFilters [
	self default searchFilters: aCollectionOfSearchFilters
]

{ #category : #'add / remove' }
GtFilterDefaultSearchFilters >> addSearchFilter: aSearchFilter [
	searchFilters := self searchFilters copyWith: aSearchFilter
]

{ #category : #'add / remove' }
GtFilterDefaultSearchFilters >> addSearchFilters: aCollectionOfSearchFilters [
	searchFilters := self searchFilters copyWithAll: aCollectionOfSearchFilters
]

{ #category : #accessing }
GtFilterDefaultSearchFilters >> collectSearchFilters [
	^ self pragmaSearchFilters
		collect: [ :eachPragma | self perform: eachPragma methodSelector ]
]

{ #category : #accessing }
GtFilterDefaultSearchFilters >> pragmaSearchFilters [
	^ Pragma
		allNamed: #gtDefaultSearchFilter:
		from: self class
		to: GtFilterDefaultSearchFilters
		sortedByArgument: 1
]

{ #category : #accessing }
GtFilterDefaultSearchFilters >> searchFilters [
	^ searchFilters ifNil: [ searchFilters := self collectSearchFilters ]
]

{ #category : #accessing }
GtFilterDefaultSearchFilters >> searchFilters: aCollectionOfSearchFilters [
	searchFilters := aCollectionOfSearchFilters
]

{ #category : #default }
GtFilterDefaultSearchFilters >> traitSearchFilter [
	<gtDefaultSearchFilter: 1>
	^ GtSearchNonTraitMethodsFilter new
]
