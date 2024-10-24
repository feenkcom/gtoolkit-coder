Class {
	#name : #GtFilterModelStringItem,
	#superclass : #GtFilterModelItem,
	#instVars : [
		'string',
		'iconStencil'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #comparing }
GtFilterModelStringItem >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	self class = anObject class ifFalse: [ ^ false ].

	^ self string sameContentAs: anObject string
]

{ #category : #comparing }
GtFilterModelStringItem >> hash [
	^ self class hash bitXor: self string hash
]

{ #category : #accessing }
GtFilterModelStringItem >> icon [
	<return: #BlElement or: nil>
	^ iconStencil ifNotNil: #asElement
]

{ #category : #accessing }
GtFilterModelStringItem >> icon: anElementStencil [
	iconStencil := anElementStencil
]

{ #category : #accessing }
GtFilterModelStringItem >> itemValue [
	^ self string
]

{ #category : #accessing }
GtFilterModelStringItem >> label [
	<return: #String or: #BlText>
	^ self string
]

{ #category : #printing }
GtFilterModelStringItem >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self string asString;
		nextPut: $)
]

{ #category : #accessing }
GtFilterModelStringItem >> string [
	^ string
]

{ #category : #accessing }
GtFilterModelStringItem >> string: aString [
	string := aString
]
