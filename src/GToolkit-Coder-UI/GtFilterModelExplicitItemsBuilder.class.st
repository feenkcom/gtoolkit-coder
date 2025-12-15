Class {
	#name : #GtFilterModelExplicitItemsBuilder,
	#superclass : #GtFilterModelItemsBuilder,
	#instVars : [
		'items'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #comparing }
GtFilterModelExplicitItemsBuilder >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	^ self class = anObject class and: [ self items = anObject items ]
]

{ #category : #'api - instantiation' }
GtFilterModelExplicitItemsBuilder >> create [
	^ self items ifNil: [ Array empty ]
]

{ #category : #'api - instantiation' }
GtFilterModelExplicitItemsBuilder >> createFuture [
	^ self create asAsyncFuture
]

{ #category : #accessing }
GtFilterModelExplicitItemsBuilder >> firstItemDo: aBlock [
	self items ifEmpty: [ ^ self ].
	aBlock cull: self items first
]

{ #category : #comparing }
GtFilterModelExplicitItemsBuilder >> hash [
	^ self class hash bitXor: self items hash
]

{ #category : #accessing }
GtFilterModelExplicitItemsBuilder >> items [
	^ items
]

{ #category : #accessing }
GtFilterModelExplicitItemsBuilder >> items: aCollection [
	items := aCollection collect: #asFilterModelItem
]

{ #category : #accessing }
GtFilterModelExplicitItemsBuilder >> lastItemDo: aBlock [
	self items ifEmpty: [ ^ self ].
	aBlock cull: self items last
]
