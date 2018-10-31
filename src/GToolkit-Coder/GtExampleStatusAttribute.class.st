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
		look: (BrGlamorousLabelLook new foreground: BrGlamorousColors defaultButtonTextColor; fontSize: 12);
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
		ifTrue: [ ^ 'N/A' asRopedText background: BrGlamorousColors lightBorderColor ].
	result isSuccess
		ifTrue: [ ^ 'Success' asRopedText background: BrGlamorousColors successBackgroundColor ].
	result isFailure
		ifTrue: [ ^ 'Failure' asRopedText background: BrGlamorousColors errorBackgroundColor ].
	^ result isError
		ifTrue: [ 'Error' asRopedText background: BrGlamorousColors errorBackgroundColor ]
		ifFalse: [ 'N/A' asRopedText background: BrGlamorousColors lightBorderColor ]
]
