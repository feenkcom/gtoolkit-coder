Class {
	#name : #GtSearchGroupResult,
	#superclass : #GtSearchResult,
	#instVars : [
		'items',
		'filter',
		'filtered',
		'scope'
	],
	#category : #'GToolkit-Coder-Filters2'
}

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

{ #category : #accessing }
GtSearchGroupResult >> highlighter [
	^ filter notNil
		ifTrue: [ filter highlighter ]
		ifFalse: [ nil ]
]

{ #category : #initialization }
GtSearchGroupResult >> initialize [
	super initialize.
	filtered := false.
	items := OrderedCollection new.
]

{ #category : #enumerating }
GtSearchGroupResult >> refreshItems [
	self subclassResponsibility
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
