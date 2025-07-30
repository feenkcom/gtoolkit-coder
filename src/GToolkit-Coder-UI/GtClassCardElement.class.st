Class {
	#name : #GtClassCardElement,
	#superclass : #GtCoderCardElement,
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'building ui' }
GtClassCardElement >> detailsLabel [
	| comment |
	comment := coder theClass organization comment.
	comment size > 100
		ifTrue: [ comment := (comment first: 100) , '...' ].
	comment := (comment replaceAllRegex: '[[:space:]]+' with: String space)
		replaceAllRegex: '[[:space:]]+' with: String space.
	^ comment asRopedText
]
