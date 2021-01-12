Class {
	#name : #GtCoderExampleStatusAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'example'
	],
	#category : #'GToolkit-Coder-AddOns-Example status'
}

{ #category : #'instance creation' }
GtCoderExampleStatusAttribute class >> forExample: anExampleWithResult [
	^ self new
		example: anExampleWithResult;
		yourself
]

{ #category : #accessing }
GtCoderExampleStatusAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	^ { GtCoderExampleStateElement new 
			example: self example;
			margin: (BlInsets top: 1 left: 2 bottom: 1 right: 1) }.
]

{ #category : #accessing }
GtCoderExampleStatusAttribute >> example [
	<return: #GtExampleWithResult or: nil>
	^ example
]

{ #category : #accessing }
GtCoderExampleStatusAttribute >> example: aGtExampleWithResult [
	example := aGtExampleWithResult asExampleWithResult.
]

{ #category : #'initialize-release' }
GtCoderExampleStatusAttribute >> initialize [
	super initialize.
	self beAppend
]

{ #category : #printing }
GtCoderExampleStatusAttribute >> printOn: aStream [
	self example ifNil: [ ^ super printOn: aStream ].
	aStream 
		nextPutAll: 'example-status: ';
		print: self example statusText.
]

{ #category : #accessing }
GtCoderExampleStatusAttribute >> result [
	^ self example ifNotNil: #result
]
