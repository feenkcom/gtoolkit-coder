Class {
	#name : #GtAstCache,
	#superclass : #Object,
	#instVars : [
		'dictionary'
	],
	#classInstVars : [
		'default'
	],
	#category : 'GToolkit-Coder-Ast'
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
GtAstCache >> cachedAstAt: anAstKey ifAbsentPut: anAbsentBlock [
	^ dictionary 
		at: anAstKey
		ifAbsentPut: anAbsentBlock
]

{ #category : #initialization }
GtAstCache >> initialize [
	super initialize.
	
	dictionary := WeakIdentityKeyDictionary new
]
