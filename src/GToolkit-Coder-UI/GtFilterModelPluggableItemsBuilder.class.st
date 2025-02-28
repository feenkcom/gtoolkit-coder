Class {
	#name : #GtFilterModelPluggableItemsBuilder,
	#superclass : #GtFilterModelItemsBuilder,
	#instVars : [
		'iconStencilBuilder',
		'labelStencilBuilder',
		'itemsBuilder'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #'api - instantiation' }
GtFilterModelPluggableItemsBuilder >> create [
	<return: #Collection of: #GtFilterModelItem>
	^ self itemsBuilder create
		collect: [ :eachItem | 
			GtFilterModelPluggableItem new
				object: eachItem itemValue;
				icon: self iconStencilBuilder;
				label: self labelStencilBuilder ]
]

{ #category : #'api - instantiation' }
GtFilterModelPluggableItemsBuilder >> createFuture [
	^ self itemsBuilder createFuture
		map: [ :anArray | 
			anArray collect: [ :eachItem | 
				GtFilterModelPluggableItem new
					object: eachItem itemValue;
					icon: self iconStencilBuilder;
					label: self labelStencilBuilder ] ]
]

{ #category : #accessing }
GtFilterModelPluggableItemsBuilder >> iconStencilBuilder [
	^ iconStencilBuilder
]

{ #category : #accessing }
GtFilterModelPluggableItemsBuilder >> iconStencilBuilder: aStencilBuilder [
	iconStencilBuilder := aStencilBuilder
			asStencilBuilder: GtFilterModelItemIconStencilBuilder
]

{ #category : #initialization }
GtFilterModelPluggableItemsBuilder >> initialize [
	super initialize.
	iconStencilBuilder := GtFilterModelItemIconStencilBuilder new.
	labelStencilBuilder := GtFilterModelItemLabelStencilBuilder new
]

{ #category : #accessing }
GtFilterModelPluggableItemsBuilder >> itemsBuilder [
	<return: #GtFilterModelItemsBuilder>
	^ itemsBuilder
]

{ #category : #accessing }
GtFilterModelPluggableItemsBuilder >> itemsBuilder: anObject [
	itemsBuilder := anObject
]

{ #category : #accessing }
GtFilterModelPluggableItemsBuilder >> labelStencilBuilder [
	^ labelStencilBuilder
]

{ #category : #accessing }
GtFilterModelPluggableItemsBuilder >> labelStencilBuilder: aStencilBuilder [
	labelStencilBuilder := aStencilBuilder
			asStencilBuilder: GtFilterModelItemLabelStencilBuilder
]
