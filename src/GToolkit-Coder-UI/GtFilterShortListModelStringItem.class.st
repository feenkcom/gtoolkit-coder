Class {
	#name : #GtFilterShortListModelStringItem,
	#superclass : #GtFilterShortListModelItem,
	#instVars : [
		'string'
	],
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #comparing }
GtFilterShortListModelStringItem >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	self class = anObject class ifFalse: [ ^ false ].

	^ self string = anObject string
]

{ #category : #comparing }
GtFilterShortListModelStringItem >> hash [
	^ self class hash bitXor: self string hash
]

{ #category : #accessing }
GtFilterShortListModelStringItem >> itemValue [
	^ self string
]

{ #category : #accessing }
GtFilterShortListModelStringItem >> label [
	<return: #String or: #BlText>
	^ self string
]

{ #category : #printing }
GtFilterShortListModelStringItem >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self string asString;
		nextPut: $)
]

{ #category : #accessing }
GtFilterShortListModelStringItem >> string [
	^ string
]

{ #category : #accessing }
GtFilterShortListModelStringItem >> string: aString [
	string := aString
]
