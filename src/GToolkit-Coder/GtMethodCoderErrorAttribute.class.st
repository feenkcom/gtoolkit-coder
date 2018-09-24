Class {
	#name : #GtMethodCoderErrorAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'string'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtMethodCoderErrorAttribute class >> for: aString [
	^ self new
		for: aString;
		beAppend;
		beNotOverwritableByStyler;
		yourself
]

{ #category : #accessing }
GtMethodCoderErrorAttribute >> affect: aBrText in: anEditorElement [
	| text attributes |
	text := string asRopedText.
	attributes := (anEditorElement editor text attributesAt: aBrText end) reject: [ :each | each = self ].
	text
		attributes: attributes;
		foreground: BrGlamorousColors defaultButtonTextColor;
		bold.
	^ (BlTextElement text: text)
		background: (BrGlamorousColors errorBackgroundColor alpha: 0.5);
		padding:
			(BlInsets
				top: 3
				left: 0
				bottom: 3
				right: 0);
		yourself
]

{ #category : #'initialize-release' }
GtMethodCoderErrorAttribute >> for: aString [
	string := aString
]
