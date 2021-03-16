Class {
	#name : #GtAstCacheCompiledPharoMethodKey,
	#superclass : #GtAstCacheKey,
	#instVars : [
		'compiledMethod'
	],
	#category : #'GToolkit-Coder-Ast'
}

{ #category : #comparing }
GtAstCacheCompiledPharoMethodKey >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ compiledMethod = anObject compiledMethod
]

{ #category : #accessing }
GtAstCacheCompiledPharoMethodKey >> compiledMethod [
	^ compiledMethod
]

{ #category : #accessing }
GtAstCacheCompiledPharoMethodKey >> compiledMethod: anObject [
	compiledMethod := anObject
]

{ #category : #comparing }
GtAstCacheCompiledPharoMethodKey >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ compiledMethod hash
]
