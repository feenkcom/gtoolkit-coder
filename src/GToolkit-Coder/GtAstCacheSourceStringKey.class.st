Class {
	#name : #GtAstCacheSourceStringKey,
	#superclass : #GtAstCacheKey,
	#instVars : [
		'sourceString'
	],
	#category : #'GToolkit-Coder-Ast'
}

{ #category : #comparing }
GtAstCacheSourceStringKey >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ sourceString = anObject sourceString
]

{ #category : #comparing }
GtAstCacheSourceStringKey >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ sourceString hash
]

{ #category : #accessing }
GtAstCacheSourceStringKey >> sourceString [
	^ sourceString
]

{ #category : #accessing }
GtAstCacheSourceStringKey >> sourceString: anObject [
	sourceString := anObject
]
