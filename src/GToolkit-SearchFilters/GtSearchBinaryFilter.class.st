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
