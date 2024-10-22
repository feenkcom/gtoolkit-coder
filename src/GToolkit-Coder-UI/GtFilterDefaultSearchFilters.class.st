Class {
	#name : #GtFilterDefaultSearchFilters,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'coderSearchFilters',
		'filterSearchFilters'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'GToolkit-Coder-UI-Filters - Support'
}

{ #category : #'add / remove' }
GtFilterDefaultSearchFilters class >> addCoderSearchFilter: aSearchFilter [
	self default addCoderSearchFilter: aSearchFilter
]

{ #category : #'add / remove' }
GtFilterDefaultSearchFilters class >> addCoderSearchFilters: aCollectionOfSearchFilters [
	self default addCoderSearchFilters: aCollectionOfSearchFilters
]

{ #category : #'add / remove' }
GtFilterDefaultSearchFilters class >> addFilterSearchFilter: aSearchFilter [
	self default addFilterSearchFilter: aSearchFilter
]

{ #category : #'add / remove' }
GtFilterDefaultSearchFilters class >> addFilterSearchFilters: aCollectionOfSearchFilters [
	self default addFilterSearchFilters: aCollectionOfSearchFilters
]

{ #category : #accessing }
GtFilterDefaultSearchFilters class >> coderSearchFilters [
	^ self default coderSearchFilters
]

{ #category : #accessing }
GtFilterDefaultSearchFilters class >> coderSearchFilters: aCollectionOfSearchFilters [
	self default coderSearchFilters: aCollectionOfSearchFilters
]

{ #category : #accessing }
GtFilterDefaultSearchFilters class >> filterSearchFilters [
	^ self default filterSearchFilters
]

{ #category : #accessing }
GtFilterDefaultSearchFilters class >> filterSearchFilters: aCollectionOfSearchFilters [
	self default filterSearchFilters: aCollectionOfSearchFilters
]

{ #category : #'add / remove' }
GtFilterDefaultSearchFilters >> addCoderSearchFilter: aSearchFilter [
	coderSearchFilters := self coderSearchFilters copyWith: aSearchFilter
]

{ #category : #'add / remove' }
GtFilterDefaultSearchFilters >> addCoderSearchFilters: aCollectionOfSearchFilters [
	coderSearchFilters := self coderSearchFilters copyWithAll: aCollectionOfSearchFilters
]

{ #category : #'add / remove' }
GtFilterDefaultSearchFilters >> addFilterSearchFilter: aSearchFilter [
	filterSearchFilters := self filterSearchFilters copyWith: aSearchFilter
]

{ #category : #'add / remove' }
GtFilterDefaultSearchFilters >> addFilterSearchFilters: aCollectionOfSearchFilters [
	filterSearchFilters := self filterSearchFilters copyWithAll: aCollectionOfSearchFilters
]

{ #category : #accessing }
GtFilterDefaultSearchFilters >> coderSearchFilters [
	^ coderSearchFilters ifNil: [ coderSearchFilters := self collectCoderSearchFilters ]
]

{ #category : #accessing }
GtFilterDefaultSearchFilters >> coderSearchFilters: aCollectionOfSearchFilters [
	coderSearchFilters := aCollectionOfSearchFilters
]

{ #category : #accessing }
GtFilterDefaultSearchFilters >> collectCoderSearchFilters [
	^ self pragmaCoderSearchFilters
		collect: [ :eachPragma | self perform: eachPragma methodSelector ]
]

{ #category : #accessing }
GtFilterDefaultSearchFilters >> collectFilterSearchFilters [
	^ self pragmaFilterSearchFilters
		collect: [ :eachPragma | self perform: eachPragma methodSelector ]
]

{ #category : #accessing }
GtFilterDefaultSearchFilters >> filterSearchFilters [
	^ filterSearchFilters ifNil: [ filterSearchFilters := self collectFilterSearchFilters ]
]

{ #category : #accessing }
GtFilterDefaultSearchFilters >> filterSearchFilters: aCollectionOfSearchFilters [
	filterSearchFilters := aCollectionOfSearchFilters
]

{ #category : #accessing }
GtFilterDefaultSearchFilters >> pragmaCoderSearchFilters [
	^ Pragma
		allNamed: #gtCoderSearchFilter:
		from: self class
		to: GtFilterDefaultSearchFilters
		sortedByArgument: 1
]

{ #category : #accessing }
GtFilterDefaultSearchFilters >> pragmaFilterSearchFilters [
	^ Pragma
		allNamed: #gtFilterSearchFilter:
		from: self class
		to: GtFilterDefaultSearchFilters
		sortedByArgument: 1
]
