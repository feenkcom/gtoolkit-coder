Class {
	#name : #GtFilterShortListModelItem,
	#superclass : #Object,
	#category : #'GToolkit-Coder-UI-Filters - Models'
}

{ #category : #comparing }
GtFilterShortListModelItem >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	self class = anObject class ifFalse: [ ^ false ].

	^ self label = anObject label
]

{ #category : #converting }
GtFilterShortListModelItem >> asFilterShortListModelItem [
	^ self
]

{ #category : #comparing }
GtFilterShortListModelItem >> hash [
	^ self class hash bitXor: self label hash
]

{ #category : #accessing }
GtFilterShortListModelItem >> ifSome: aBlock [
	^ self ifSome: aBlock ifNone: [ nil ]
]

{ #category : #accessing }
GtFilterShortListModelItem >> ifSome: aBlock ifNone: aNoneBlock [
	^ aBlock cull: self itemValue cull: self
]

{ #category : #accessing }
GtFilterShortListModelItem >> itemValue [
	^ self
]

{ #category : #accessing }
GtFilterShortListModelItem >> label [
	<return: #String or: #BlText>
	^ self subclassResponsibility
]

{ #category : #accessing }
GtFilterShortListModelItem >> labelSize [
	<return: #Integer>
	^ self label size
]
