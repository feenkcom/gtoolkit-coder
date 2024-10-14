Class {
	#name : #GtFilterModelItemIconStencilBuilder,
	#superclass : #BrStencilBuilder,
	#instVars : [
		'object'
	],
	#category : #'GToolkit-Coder-UI-Filters - Support'
}

{ #category : #'api - instantiation' }
GtFilterModelItemIconStencilBuilder >> buildDefault [
	<return: #BlElement or: nil>
	| anIconName |
	anIconName := self object gtIconName.
	(anIconName isNil or: [ anIconName = Object gtIconName ]) ifTrue: [ ^ nil ].

	^ (self object gtSafeIconNamed: anIconName) ifNotNil: #asElement
]

{ #category : #accessing }
GtFilterModelItemIconStencilBuilder >> object [
	^ object
]

{ #category : #accessing }
GtFilterModelItemIconStencilBuilder >> object: anObject [
	object := anObject
]

{ #category : #'api - instantiation' }
GtFilterModelItemIconStencilBuilder >> paramsOn: aStencilExecutor [
	super paramsOn: aStencilExecutor.

	aStencilExecutor push: object
]

{ #category : #initialization }
GtFilterModelItemIconStencilBuilder >> reset [
	object := nil
]
