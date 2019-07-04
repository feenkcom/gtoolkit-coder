Class {
	#name : #GtCoderElementHolder,
	#superclass : #BlInfiniteHolder,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtCoderElementHolder >> coderElement: anElement [
	anElement removeFromParent.
	self initializeWith: anElement
]
