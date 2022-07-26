Class {
	#name : #GtSourceCoderErrorAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'string'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Attributes'
}

{ #category : #'instance creation' }
GtSourceCoderErrorAttribute class >> for: aString [
	^ self new
		for: aString;
		beAppend;
		beNotOverwritableByStyler;
		yourself
]

{ #category : #accessing }
GtSourceCoderErrorAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	| text element |
	text := string asRopedText
			foreground: BrGlamorousColors defaultButtonTextColor;
			medium;
			glamorousCodeFontAndSmallSize.
	element := BlTextElement new
			text: text;
			background: (BrGlamorousColors errorBackgroundColor alpha: 0.4);
			padding: (BlInsets
					top: 3
					left: 0
					bottom: 3
					right: 0);
			margin: (BlInsets left: 2 right: 2);
			yourself.
	element userData at: #sourceError put: true.

	^ element
]

{ #category : #'initialize-release' }
GtSourceCoderErrorAttribute >> for: aString [
	string := aString
]
