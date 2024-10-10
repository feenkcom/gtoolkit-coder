Class {
	#name : #GtFilterModelPluggableItem,
	#superclass : #GtFilterModelItem,
	#instVars : [
		'object',
		'iconStencilBuilder',
		'labelStencilBuilder'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #'instance creation' }
GtFilterModelPluggableItem class >> forCollection: aCollection icon: anIconStencilBuilder label: aLabelStencilBuilder [
	^ aCollection
		collect: [ :eachObject | 
			self new
				object: eachObject;
				icon: anIconStencilBuilder;
				label: aLabelStencilBuilder ]
]

{ #category : #accessing }
GtFilterModelPluggableItem >> icon [
	<return: #BlElement>
	^ iconStencilBuilder
		object: self object;
		asElement
]

{ #category : #accessing }
GtFilterModelPluggableItem >> icon: aStencilBuilder [
	iconStencilBuilder := aStencilBuilder
			asStencilBuilder: GtFilterModelItemIconStencilBuilder new
]

{ #category : #initialization }
GtFilterModelPluggableItem >> initialize [
	super initialize.
	iconStencilBuilder := GtFilterModelItemIconStencilBuilder new.
	labelStencilBuilder := GtFilterModelItemLabelStencilBuilder new
]

{ #category : #accessing }
GtFilterModelPluggableItem >> itemValue [
	^ self object
]

{ #category : #accessing }
GtFilterModelPluggableItem >> label [
	<return: #String>
	^ labelStencilBuilder
		object: self object;
		create
]

{ #category : #accessing }
GtFilterModelPluggableItem >> label: aStencilBuilder [
	labelStencilBuilder := aStencilBuilder
			asStencilBuilder: GtFilterModelItemLabelStencilBuilder new
]

{ #category : #accessing }
GtFilterModelPluggableItem >> object [
	^ object
]

{ #category : #accessing }
GtFilterModelPluggableItem >> object: anObject [
	object := anObject
]
