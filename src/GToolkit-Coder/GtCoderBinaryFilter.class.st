Class {
	#name : #GtCoderBinaryFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'left',
		'right'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #'instance creation' }
GtCoderBinaryFilter class >> forFilter: leftFilter filter: rightFilter [
	^ self new
		filter: leftFilter filter: rightFilter;
		yourself
]

{ #category : #'initialize-release' }
GtCoderBinaryFilter >> filter: leftFilter filter: rightFilter [
	left := leftFilter.
	right := rightFilter
]

{ #category : #accessing }
GtCoderBinaryFilter >> highlighter [
	^ left highlighter
		ifNil: [ right highlighter ]
		ifNotNil: [ :lh | 
			right highlighter
				ifNil: [ lh ]
				ifNotNil:
					[ :rh | GtCompositeHighlighter forHighlighters: (Array with: lh with: rh) ] ]
]
