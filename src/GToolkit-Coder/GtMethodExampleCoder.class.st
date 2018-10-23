Class {
	#name : #GtMethodExampleCoder,
	#superclass : #GtMethodCoder,
	#instVars : [
		'example'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'as yet unclassified' }
GtMethodExampleCoder class >> forExample: anExample [
	^ self new example: anExample 
]

{ #category : #accessing }
GtMethodExampleCoder >> example [
	^ example
]

{ #category : #accessing }
GtMethodExampleCoder >> example: anObject [
	example := anObject
]
