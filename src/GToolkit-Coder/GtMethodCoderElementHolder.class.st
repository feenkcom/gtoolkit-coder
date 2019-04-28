Class {
	#name : #GtMethodCoderElementHolder,
	#superclass : #BlInfiniteHolder,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtMethodCoderElementHolder >> methodCoderElement: anElement [
	anElement removeFromParent.
	self initializeWith: anElement
]
