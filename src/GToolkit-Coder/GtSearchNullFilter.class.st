Class {
	#name : 'GtSearchNullFilter',
	#superclass : 'GtSearchFilter',
	#category : 'GToolkit-Coder-Filters'
}

{ #category : 'comparing' }
GtSearchNullFilter >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^ true
]

{ #category : 'accessing' }
GtSearchNullFilter >> defaultFilterScope [
	^ self
]

{ #category : 'enumerating' }
GtSearchNullFilter >> itemsDo: aBloc [
]

{ #category : 'testing' }
GtSearchNullFilter >> matches: anObject [
	^ false
]
