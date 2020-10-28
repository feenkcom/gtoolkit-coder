Class {
	#name : #GtCoderClassOneLineElement,
	#superclass : #GtCoderOneLineElement,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtCoderClassOneLineElement >> detailsLabel [
	| comment |
	comment := coder theClass organization comment.
	comment size > 100 ifTrue: [ comment := (comment first: 100) , '...' ].
	^ comment asRopedText
]
