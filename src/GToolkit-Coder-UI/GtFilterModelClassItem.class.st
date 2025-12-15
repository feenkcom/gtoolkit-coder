Class {
	#name : #GtFilterModelClassItem,
	#superclass : #GtFilterModelItem,
	#instVars : [
		'itemClass'
	],
	#category : 'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterModelClassItem >> icon [
	| anIconName |
	self itemClass ifNil: [ ^ nil ].

	anIconName := self itemClass gtSystemIconName.
	anIconName ifNil: [ ^ nil ].

	^ self itemClass gtSafeIconNamed: anIconName
]

{ #category : #accessing }
GtFilterModelClassItem >> itemClass [
	^ itemClass
]

{ #category : #accessing }
GtFilterModelClassItem >> itemClass: anObject [
	itemClass := anObject
]

{ #category : #accessing }
GtFilterModelClassItem >> itemSymbol [
	^ self itemClass instanceSide name asSymbol
]

{ #category : #accessing }
GtFilterModelClassItem >> itemValue [
	^ self itemClass
]

{ #category : #accessing }
GtFilterModelClassItem >> label [
	<return: #String>
	^ self itemClass name
]

{ #category : #printing }
GtFilterModelClassItem >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		print: self itemClass;
		nextPut: $)
]
