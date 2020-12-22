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
	| text attributes |

	text := string asRopedText.
	attributes := (anEditorElement editor text attributesAt: aTBrTextEditorTextualPiece textEnd) reject: [ :each | each = self ].

	text
		attributes: attributes;
		foreground: BrGlamorousColors defaultButtonTextColor;
		bold.

	^ (BlTextElement text: text)
		background: (BrGlamorousColors errorBackgroundColor alpha: 0.5);
		padding: (BlInsets top: 3 left: 0 bottom: 3 right: 0);
		yourself
]

{ #category : #'initialize-release' }
GtSourceCoderErrorAttribute >> for: aString [
	string := aString
]
