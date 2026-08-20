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
	| filterCode|
	filterCode := String streamContents: [ :anotherStream |
		anotherStream parenthesize: [ 
			left storeCreationCodeOn: anotherStream ].
		anotherStream nextPutAll: ''.
		anotherStream nextPutAll: self filterOperatorForCodeCreation.
		anotherStream nextPutAll: ''.
		anotherStream parenthesize: [ 
			right storeCreationCodeOn: anotherStream ] ].

	aStream nextPutAll: (RBParser parseExpression: filterCode) formattedCode
]
