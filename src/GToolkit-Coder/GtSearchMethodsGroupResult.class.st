Class {
	#name : #GtSearchMethodsGroupResult,
	#superclass : #GtSearchGroupResult,
	#instVars : [
		'methods',
		'filter',
		'scope',
		'filtered'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #converting }
GtSearchMethodsGroupResult >> asCoder [
	^ GtFilteredMethodsCoder forMethods: self
]

{ #category : #converting }
GtSearchMethodsGroupResult >> asElement [
	^ self asCoder asElement 
]

{ #category : #enumerating }
GtSearchMethodsGroupResult >> collect: aBlock [
	self refreshMethods.
	^ methods collect: aBlock
]

{ #category : #enumerating }
GtSearchMethodsGroupResult >> do: aBlock [
	self refreshMethods.
	^ methods do: aBlock
]

{ #category : #accessing }
GtSearchMethodsGroupResult >> filter [
	^ filter
]

{ #category : #accessing }
GtSearchMethodsGroupResult >> filter: coderMethodsFilter [
	filtered := false.
	methods := OrderedCollection new.
	filter := coderMethodsFilter
]

{ #category : #ui }
GtSearchMethodsGroupResult >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 10;
		stencil: [ self asCoder ]
]

{ #category : #accessing }
GtSearchMethodsGroupResult >> highlighter [
	^ filter notNil
		ifTrue: [ filter highlighter ]
		ifFalse: [ nil ]
]

{ #category : #'initialize-release' }
GtSearchMethodsGroupResult >> initialize [
	super initialize.
	filtered := false.
	methods := OrderedCollection new.
]

{ #category : #enumerating }
GtSearchMethodsGroupResult >> refreshMethods [
	filtered
		ifTrue: [ ^ self ].
	methods := OrderedCollection new.
	filter ifNotNil: [ 
		"The actual filtering should be dipatched through the filter"
		scope methodsDo: [ :aCompiledMethod | 
			(filter matches: aCompiledMethod) ifTrue: [
				methods add: aCompiledMethod ] ] ].
	methods
		sort: [ :a :b | 
			a methodClass = b methodClass
				ifTrue: [ a selector < b selector ]
				ifFalse: [ a methodClass name < b methodClass name ] ].
	filtered := true
]

{ #category : #removing }
GtSearchMethodsGroupResult >> remove: aMethod ifAbsent: aBlock [
	self refreshMethods.
	^ methods remove: aMethod ifAbsent: aBlock
]

{ #category : #accessing }
GtSearchMethodsGroupResult >> scope [
	^ scope
]

{ #category : #accessing }
GtSearchMethodsGroupResult >> scope: aSearchScope [
	scope := aSearchScope
]

{ #category : #accessing }
GtSearchMethodsGroupResult >> size [
	self refreshMethods.
	^ methods size
]

{ #category : #private }
GtSearchMethodsGroupResult >> species [
	self refreshMethods.
	^ methods class
]
