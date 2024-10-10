Class {
	#name : #GtFilterModelObjectItem,
	#superclass : #GtFilterModelItem,
	#instVars : [
		'object'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterModelObjectItem >> icon [
	| anIconName |
	anIconName := self object gtIconName.
	(anIconName isNil or: [ anIconName = Object gtIconName ]) ifTrue: [ ^ nil ].

	^ self object gtSafeIconNamed: anIconName
]

{ #category : #accessing }
GtFilterModelObjectItem >> itemValue [
	^ self object
]

{ #category : #accessing }
GtFilterModelObjectItem >> label [
	<return: #String>
	^ self object asString
]

{ #category : #accessing }
GtFilterModelObjectItem >> object [
	^ object
]

{ #category : #accessing }
GtFilterModelObjectItem >> object: anObject [
	object := anObject
]

{ #category : #printing }
GtFilterModelObjectItem >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		print: self object;
		nextPut: $)
]
