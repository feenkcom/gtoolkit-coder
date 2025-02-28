Class {
	#name : #GtFilterModelValuableItemsBuilder,
	#superclass : #GtFilterModelItemsBuilder,
	#instVars : [
		'valuable'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #comparing }
GtFilterModelValuableItemsBuilder >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	^ self class = anObject class and: [ self valuable = anObject valuable ]
]

{ #category : #'api - instantiation' }
GtFilterModelValuableItemsBuilder >> create [
	^ self valuable value collect: #asFilterModelItem
]

{ #category : #'api - instantiation' }
GtFilterModelValuableItemsBuilder >> createFuture [
	^ [ self create ] asAsyncFuture
]

{ #category : #comparing }
GtFilterModelValuableItemsBuilder >> hash [
	^ self class hash bitXor: self valuable hash
]

{ #category : #accessing }
GtFilterModelValuableItemsBuilder >> valuable [
	^ valuable
]

{ #category : #accessing }
GtFilterModelValuableItemsBuilder >> valuable: aValuable [
	valuable := aValuable
]
