Class {
	#name : #GtExampleStatusAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'example'
	],
	#category : #'GToolkit-Coder-AddOns-Example'
}

{ #category : #'instance creation' }
GtExampleStatusAttribute class >> forExample: anExampleWithResult [
	^ self new
		example: anExampleWithResult;
		yourself
]

{ #category : #accessing }
GtExampleStatusAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	^ { GtCoderExampleStateElement new 
			example: self example;
			margin: (BlInsets top: 1 left: 2 bottom: 1 right: 1) }.
]

{ #category : #accessing }
GtExampleStatusAttribute >> example [
	<return: #GtExampleWithResult or: nil>
	^ example
]

{ #category : #accessing }
GtExampleStatusAttribute >> example: aGtExampleWithResult [
	example := aGtExampleWithResult asExampleWithResult.
]

{ #category : #'initialize-release' }
GtExampleStatusAttribute >> initialize [
	super initialize.
	self beAppend
]

{ #category : #accessing }
GtExampleStatusAttribute >> result [
	^ self example ifNotNil: #result
]
