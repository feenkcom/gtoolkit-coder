Class {
	#name : #GtSearchBinaryFilter,
	#superclass : #GtSearchFilter,
	#instVars : [
		'left',
		'right'
	],
	#category : #'GToolkit-Coder-Filters'
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
GtSearchBinaryFilter >> highlighter [
	^ left highlighter
		ifNil: [ right highlighter ]
		ifNotNil: [ :lh | 
			right highlighter
				ifNil: [ lh ]
				ifNotNil:
					[ :rh | GtCompositeHighlighter forHighlighters: (Array with: lh with: rh) ] ]
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
