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
GtFilterShortListModelItem >> label [
	<return: #String or: #BlText>
	^ self subclassResponsibility
]

{ #category : #accessing }
GtFilterShortListModelItem >> labelSize [
	<return: #Integer>
	^ self label size
]
