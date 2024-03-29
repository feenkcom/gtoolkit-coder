Class {
	#name : #GtSearchNullFilter,
	#superclass : #GtSearchFilter,
	#category : #'GToolkit-SearchFilters-Filters'
}

{ #category : #comparing }
GtSearchNullFilter >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ true
]

{ #category : #accessing }
GtSearchNullFilter >> defaultFilterScope [
	^ AsyncEmptyStream new
]

{ #category : #comparing }
GtSearchNullFilter >> hash [
	^self class hash
]

{ #category : #enumerating }
GtSearchNullFilter >> itemsDo: aBloc [
]

{ #category : #testing }
GtSearchNullFilter >> matches: anObject [
	^ false
]
