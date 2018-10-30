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
	| text attributes element |
	text := self resultLabel asRopedText.
	attributes := (anEditorElement editor text attributesAt: aBrText end) reject: [ :each | each = self ].
	text
		attributes: attributes;
		foreground: BrGlamorousColors defaultButtonTextColor;
		thin.
	element := BlTextElement text: text.
	(result notNil and: [ result isError ])
		ifTrue: [ element background: (BrGlamorousColors errorBackgroundColor alpha: 0.5) ].
	element
		margin: (BlInsets left: 5);
		padding:
			(BlInsets
				top: 3
				left: 0
				bottom: 3
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
		ifTrue: [ ^ 'N/A' ].
	result isSuccess
		ifTrue: [ ^ 'Success' ].
	result isFailure
		ifTrue: [ ^ 'Failure' ].
	^ result isError
		ifTrue: [ 'Error' ]
		ifFalse: [ 'N/A' ]
]
