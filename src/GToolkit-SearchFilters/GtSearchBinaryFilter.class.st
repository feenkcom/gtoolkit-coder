Class {
	#name : #GtSearchBinaryFilter,
	#superclass : #GtSearchFilter,
	#instVars : [
		'left',
		'right'
	],
	#category : #'GToolkit-SearchFilters'
}

{ #category : #'instance creation' }
GtSearchBinaryFilter class >> forFilter: leftFilter filter: rightFilter [
	^ self new
		filter: leftFilter filter: rightFilter;
		yourself
]

{ #category : #'initialize-release' }
GtSearchBinaryFilter >> filter: leftFilter filter: rightFilter [
	left := leftFilter.
	right := rightFilter
]

{ #category : #storing }
GtSearchBinaryFilter >> filterOperatorForCodeCreation [
	self subclassResponsibility
]

{ #category : #accessing }
GtSearchBinaryFilter >> filterValueString [
	^ left filterValueString
		ifNil: [ right filterValueString ]
]

{ #category : #accessing }
GtSearchBinaryFilter >> leftFilter [
	^ left
]

{ #category : #accessing }
GtSearchBinaryFilter >> resultType [
	^ left resultType mergeTypeWith: right resultType
]

{ #category : #accessing }
GtSearchBinaryFilter >> rightFilter [
	^ right
]

{ #category : #storing }
GtSearchBinaryFilter >> storeCreationCodeOn: aStream [
	aStream parenthesize: [ left storeCreationCodeOn: aStream ].
	aStream nextPutAll: ''.
	aStream nextPutAll: self filterOperatorForCodeCreation.
	aStream nextPutAll: ''.
	aStream parenthesize: [ right storeCreationCodeOn: aStream ]
]
