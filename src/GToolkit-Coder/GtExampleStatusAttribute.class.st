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
	| aButtonElement |
	aButtonElement := BrButton new
		look: (BrGlamorousLabelLook new fontSize: 12);
		label: self resultLabel.
	(result notNil and: [ result isError ])
		ifTrue: [ aButtonElement background: (BrGlamorousColors errorBackgroundColor alpha: 0.5) ].
	aButtonElement padding: (BlInsets top: 4 left: 0 bottom: 0 right: 0).
	aButtonElement margin: (BlInsets left: 5).
	result ifNil: [ ^ aButtonElement ].
	result isSuccess ifTrue: [ 
		aButtonElement action: [ :aButton | aButton phlow spawnObject: self result returnValue ] ].
	(result isFailure or: [ result isError ]) ifTrue: [ 
		aButtonElement action: [ :aButton | self result exampleException debug ] ].
	^ aButtonElement
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
