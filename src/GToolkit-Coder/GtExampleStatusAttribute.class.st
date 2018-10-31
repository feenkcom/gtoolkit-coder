Class {
	#name : #GtExampleStatusAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'result'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtExampleStatusAttribute class >> forResult: anExampleResult [
	^ self new
		result: anExampleResult;
		yourself
]

{ #category : #accessing }
GtExampleStatusAttribute >> affect: aBrText in: anEditorElement [
	| element |
	element := BrLabel new
		look: (BrGlamorousLabelLook new fontSize: 12);
		text: self resultLabel.
	(result notNil and: [ result isError ])
		ifTrue: [ element background: (BrGlamorousColors errorBackgroundColor alpha: 0.5) ].
	element margin: (BlInsets left: 5);
		padding:
			(BlInsets
				top: 4
				left: 0
				bottom: 0
				right: 0).
	^ element
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
