Class {
	#name : #GtSearchMethodGroupResult,
	#superclass : #GtSearchTypedGroupResult,
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #converting }
GtSearchMethodGroupResult >> asCoder [
	^ GtFilteredMethodsCoder forMethods: self
]

{ #category : #converting }
GtSearchMethodGroupResult >> asElement [
	^ self asCoder asElement 
]

{ #category : #ui }
GtSearchMethodGroupResult >> gtItemsFor: aView [
	^ aView explicit 
		title: 'Live' translated;
		priority: 10;
		stencil: [ self asCoder ]
]

{ #category : #enumerating }
GtSearchMethodGroupResult >> refreshItems [
	self refreshMethods
]

{ #category : #enumerating }
GtSearchMethodGroupResult >> refreshMethods [
	| methods |
	filtered
		ifTrue: [ ^ self ].
	methods := OrderedCollection new.
	filter ifNotNil: [ 
		"The actual filtering should be dipatched through the filter"
		scope itemsDo: [ :aCompiledMethod | 
			(filter matches: aCompiledMethod) ifTrue: [
				methods add: aCompiledMethod ] ] ].
	methods
		sort: [ :a :b | 
			a methodClass = b methodClass
				ifTrue: [ a selector < b selector ]
				ifFalse: [ a methodClass name < b methodClass name ] ].
	items := methods.
	filtered := true.
]
