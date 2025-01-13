Class {
	#name : #GtFilterModelPluggableItem,
	#superclass : #GtFilterModelItem,
	#instVars : [
		'object',
		'iconStencilBuilder',
		'labelStencilBuilder',
		'filterUpdater'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #'instance creation' }
GtFilterModelPluggableItem class >> forCollection: aCollection icon: anIconStencilBuilder [
	^ aCollection
		collect: [ :eachObject | 
			self new
				object: eachObject;
				icon: anIconStencilBuilder ]
]

{ #category : #'instance creation' }
GtFilterModelPluggableItem class >> forCollection: aCollection icon: anIconStencilBuilder label: aLabelStencilBuilder [
	^ aCollection
		collect: [ :eachObject | 
			self new
				object: eachObject;
				icon: anIconStencilBuilder;
				label: aLabelStencilBuilder ]
]

{ #category : #'instance creation' }
GtFilterModelPluggableItem class >> forCollection: aCollection label: aLabelStencilBuilder [
	^ aCollection
		collect: [ :eachObject | 
			self new
				object: eachObject;
				label: aLabelStencilBuilder ]
]

{ #category : #'instance creation' }
GtFilterModelPluggableItem class >> forObject: anObject icon: anIconStencilBuilder [
	^ self new
		object: anObject;
		icon: anIconStencilBuilder
]

{ #category : #'instance creation' }
GtFilterModelPluggableItem class >> forObject: anObject icon: anIconStencilBuilder label: aLabelStencilBuilder [
	^ self new
		object: anObject;
		icon: anIconStencilBuilder;
		label: aLabelStencilBuilder
]

{ #category : #'instance creation' }
GtFilterModelPluggableItem class >> forObject: anObject label: aLabelStencilBuilder [
	^ self new
		object: anObject;
		label: aLabelStencilBuilder
]

{ #category : #accessing }
GtFilterModelPluggableItem >> filterUpdater [
	^ filterUpdater
]

{ #category : #accessing }
GtFilterModelPluggableItem >> filterUpdater: aBlock [
	"Set a filter block that is called when a filter model is updated and new filter created.
	It receives two arguments: [ :aFilter :anItem | ]."

	filterUpdater := aBlock
]

{ #category : #accessing }
GtFilterModelPluggableItem >> icon [
	<return: #BlElement or: nil>
	^ iconStencilBuilder
		object: self object;
		build
]

{ #category : #accessing }
GtFilterModelPluggableItem >> icon: aStencilBuilder [
	iconStencilBuilder := aStencilBuilder
			asStencilBuilder: GtFilterModelItemIconStencilBuilder
]

{ #category : #initialization }
GtFilterModelPluggableItem >> initialize [
	super initialize.
	iconStencilBuilder := GtFilterModelItemIconStencilBuilder new.
	labelStencilBuilder := GtFilterModelItemLabelStencilBuilder new.
	filterUpdater := [ :aFilter :anItem | "do nothing" ]
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
		build
]

{ #category : #accessing }
GtFilterModelPluggableItem >> label: aStencilBuilder [
	labelStencilBuilder := aStencilBuilder
			asStencilBuilder: GtFilterModelItemLabelStencilBuilder
]

{ #category : #accessing }
GtFilterModelPluggableItem >> object [
	^ object
]

{ #category : #accessing }
GtFilterModelPluggableItem >> object: anObject [
	object := anObject
]

{ #category : #converting }
GtFilterModelPluggableItem >> onCreateFilter: aFilter [
	filterUpdater ifNil: [ ^ self ].
	filterUpdater cull: aFilter cull: self
]

{ #category : #printing }
GtFilterModelPluggableItem >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		print: self object;
		nextPut: $)
]
