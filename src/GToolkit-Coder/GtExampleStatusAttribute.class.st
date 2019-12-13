Class {
	#name : #GtExampleStatusAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'result'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'instance creation' }
GtExampleStatusAttribute class >> forResult: anExampleResult [
	^ self new
		result: anExampleResult;
		yourself
]

{ #category : #accessing }
GtExampleStatusAttribute >> affect: aTBrTextEditorTextualPiece in: anEditorElement [
	| aLabelElement |
	aLabelElement := BrLabel new
		look: (BrGlamorousLabelLook new fontSize: 12);
		text: self resultLabel.
	(result notNil and: [ result isError ])
		ifTrue: [ aLabelElement background: (BrGlamorousColors errorBackgroundColor alpha: 0.5) ].
	aLabelElement padding: (BlInsets top: 4 left: 0 bottom: 0 right: 0).
	aLabelElement margin: (BlInsets left: 5).
	result ifNil: [ ^ aLabelElement ].
	result isSuccess ifTrue: [ 
		aLabelElement addViewModel: (BrButtonModel new 
				action: [ :aButton | aButton phlow spawnObject: self result returnValue ]) ].
	(result isFailure or: [ result isError ]) ifTrue: [ 
		aLabelElement addViewModel: (BrButtonModel new 
				action: [ :aButton | self result exampleException debug ]) ].
	^ aLabelElement
]

{ #category : #'initialize-release' }
GtExampleStatusAttribute >> initialize [
	super initialize.
	self beAppend
]

{ #category : #accessing }
GtExampleStatusAttribute >> result [
	^ result
]

{ #category : #accessing }
GtExampleStatusAttribute >> result: exampleResult [
	result := exampleResult
]

{ #category : #accessing }
GtExampleStatusAttribute >> resultLabel [
	result isNil
		ifTrue: [ ^ 'N/A' asRopedText foreground: BrGlamorousColors lightBorderColor ].
	result isSuccess
		ifTrue: [ ^ 'Success' asRopedText foreground: BrGlamorousColors successBorderColor ].
	result isFailure
		ifTrue: [ ^ 'Failure' asRopedText foreground: BrGlamorousColors errorBorderColor ].
	^ result isError
		ifTrue: [ 'Error' asRopedText foreground: BrGlamorousColors errorBorderColor ]
		ifFalse: [ 'N/A' asRopedText foreground: BrGlamorousColors lightBorderColor ]
]
