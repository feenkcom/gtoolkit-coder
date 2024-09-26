Class {
	#name : #GtFilterShortListModelClassItem,
	#superclass : #GtFilterShortListModelItem,
	#instVars : [
		'itemClass'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #accessing }
GtFilterShortListModelClassItem >> itemClass [
	^ itemClass
]

{ #category : #accessing }
GtFilterShortListModelClassItem >> itemClass: anObject [
	itemClass := anObject
]

{ #category : #accessing }
GtFilterShortListModelClassItem >> itemSymbol [
	^ self itemClass instanceSide name asSymbol
]

{ #category : #accessing }
GtFilterShortListModelClassItem >> label [
	<return: #String>
	^ self itemClass name
]

{ #category : #printing }
GtFilterShortListModelClassItem >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		print: self itemClass;
		nextPut: $)
]
