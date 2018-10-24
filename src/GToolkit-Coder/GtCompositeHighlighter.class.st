Class {
	#name : #GtCompositeHighlighter,
	#superclass : #GtSourceReferenceHighlighter,
	#instVars : [
		'highlighters'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtCompositeHighlighter class >> forHighlighters: aCollection [
	^ self new
		forHighlighters: aCollection;
		yourself
]

{ #category : #'initialize-release' }
GtCompositeHighlighter >> forHighlighters: aCollection [
	highlighters := aCollection
]

{ #category : #testing }
GtCompositeHighlighter >> shouldHighlight: aNode [
	^ highlighters anySatisfy: [ :each | each shouldHighlight: aNode ]
]
