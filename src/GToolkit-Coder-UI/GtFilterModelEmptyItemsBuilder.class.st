Class {
	#name : #GtFilterModelEmptyItemsBuilder,
	#superclass : #GtFilterModelItemsBuilder,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #'api - instantiation' }
GtFilterModelEmptyItemsBuilder >> create [
	^ Array empty
]

{ #category : #'api - instantiation' }
GtFilterModelEmptyItemsBuilder >> createFuture [
	^ Array empty asAsyncFuture
]

{ #category : #accessing }
GtFilterModelEmptyItemsBuilder >> firstItemDo: aBlock [
	"do nothing"
]

{ #category : #accessing }
GtFilterModelEmptyItemsBuilder >> lastItemDo: aBlock [
	"do nothing"
]
