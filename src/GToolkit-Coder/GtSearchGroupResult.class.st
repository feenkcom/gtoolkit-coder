Class {
	#name : #GtSearchGroupResult,
	#superclass : #Object,
	#instVars : [
		'items',
		'filter',
		'filtered',
		'scope'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'as yet unclassified' }
GtSearchGroupResult class >> mergeTypeWith: aGroupResultClass [
	^ aGroupResultClass mergeTypeWithDefaultGroup
]

{ #category : #'as yet unclassified' }
GtSearchGroupResult class >> mergeTypeWithDefaultGroup [
	"The common type between the default group and any other group is the other group."
	^ self
]

{ #category : #'as yet unclassified' }
GtSearchGroupResult class >> mergeTypeWithGenericGroup [
	"The common type between a generic group and any other group is the other group."
	^ self
]

{ #category : #'as yet unclassified' }
GtSearchGroupResult class >> mergeTypeWithTypedGroup: aGroupType [
	^ self
]

{ #category : #adding }
GtSearchGroupResult >> add: anObject [
	self refreshItems.
	^ items add: anObject
]

{ #category : #enumerating }
GtSearchGroupResult >> collect: aBlock [
	self refreshItems.
	^ items collect: aBlock
]

{ #category : #enumerating }
GtSearchGroupResult >> do: aBlock [
	self refreshItems.
	^ items do: aBlock
]

{ #category : #accessing }
GtSearchGroupResult >> filter [
	^ filter
]

{ #category : #accessing }
GtSearchGroupResult >> filter: methodsFilter [
	filtered := false.
	items := OrderedCollection new.
	filter := methodsFilter
]

{ #category : #ui }
GtSearchGroupResult >> gtItemsFor: aView [
	<gtView>
	self refreshItems.
	^ aView list 
		title: 'Items' translated;
		priority: 10;
		items: [ items ifNil: [ #() ] ]
]

{ #category : #accessing }
GtSearchGroupResult >> highlighter [
	^ filter notNil
		ifTrue: [ filter highlighter ]
		ifFalse: [ nil ]
]

{ #category : #'as yet unclassified' }
GtSearchGroupResult >> includes: aCollection [ 
	self refreshItems.
	^ items includes: aCollection
]

{ #category : #initialization }
GtSearchGroupResult >> initialize [
	super initialize.
	filtered := false.
	items := OrderedCollection new.
]

{ #category : #testing }
GtSearchGroupResult >> isEmpty [
	"Answer whether the receiver contains any elements."
	^ self size = 0
]

{ #category : #enumerating }
GtSearchGroupResult >> refreshItems [
	| filteredItems |
	filtered
		ifTrue: [ ^ self ].
	filteredItems := OrderedCollection new.
	filter ifNotNil: [ 
		scope itemsDo: [ :anObject | 
			(filter matches: anObject) ifTrue: [
				filteredItems add: anObject ] ] ].
	items := filteredItems.
	filtered := true.
]

{ #category : #removing }
GtSearchGroupResult >> remove: anItem ifAbsent: aBlock [
	self refreshItems.
	^ items remove: anItem ifAbsent: aBlock
]

{ #category : #accessing }
GtSearchGroupResult >> scope [
	^ scope
]

{ #category : #accessing }
GtSearchGroupResult >> scope: aSearchScope [
	scope := aSearchScope
]

{ #category : #accessing }
GtSearchGroupResult >> size [
	self refreshItems.
	^ items size
]

{ #category : #private }
GtSearchGroupResult >> species [
	self refreshItems.
	^ items class
]

{ #category : #enumerating }
GtSearchGroupResult >> sumNumbers: aBlock [
	self refreshItems.
	^ items sumNumbers: aBlock
]

{ #category : #initialization }
GtSearchGroupResult >> updateForFilter: aFilter [
	self filter: aFilter.
	self scope: (aFilter 
		ifNil: [ GtSearchNullFilter new ]
		ifNotNil: [  aFilter defaultFilterScope ])
]
