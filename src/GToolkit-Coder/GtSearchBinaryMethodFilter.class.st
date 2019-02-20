Class {
	#name : #GtSearchBinaryMethodFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'left',
		'right'
	],
	#category : #'GToolkit-Coder-Filters2'
}

{ #category : #'instance creation' }
GtSearchBinaryMethodFilter class >> forFilter: leftFilter filter: rightFilter [
	^ self new
		filter: leftFilter filter: rightFilter;
		yourself
]

{ #category : #'initialize-release' }
GtSearchBinaryMethodFilter >> filter: leftFilter filter: rightFilter [
	left := leftFilter.
	right := rightFilter
]

{ #category : #accessing }
GtSearchBinaryMethodFilter >> highlighter [
	^ left highlighter
		ifNil: [ right highlighter ]
		ifNotNil: [ :lh | 
			right highlighter
				ifNil: [ lh ]
				ifNotNil:
					[ :rh | GtCompositeHighlighter forHighlighters: (Array with: lh with: rh) ] ]
]

{ #category : #testing }
GtSearchBinaryMethodFilter >> isMethodFilter [
	^ left isMethodFilter and: [ right isMethodFilter ]
]
