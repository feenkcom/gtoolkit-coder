Class {
	#name : #GtAstCache,
	#superclass : #Object,
	#instVars : [
		'dictionary'
	],
	#classInstVars : [
		'default'
	],
	#category : #'GToolkit-Coder-Ast'
}

{ #category : #accessing }
GtAstCache class >> cleanUp [
	default := nil
]

{ #category : #accessing }
GtAstCache class >> default [
	^ default ifNil: [ default := self new ]
]

{ #category : #accessing }
GtAstCache >> cachedAstAt: aGtAstCacheKey ifAbsentPut: anAbsentBlock [
	^ dictionary 
		at: aGtAstCacheKey
		ifAbsentPut: anAbsentBlock
]

{ #category : #initialization }
GtAstCache >> initialize [
	super initialize.
	
	dictionary := WeakKeyDictionary new
]
