Class {
	#name : #GtCoderPrintStringAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'string'
	],
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #'instance creation' }
GtCoderPrintStringAttribute class >> forString: aString [
	^ self new
		string: aString;
		yourself
]

{ #category : #accessing }
GtCoderPrintStringAttribute >> affect: aTBrTextEditorTextualPiece in: anEditorElement [
	| element |
	element := BrLabel new
		look: (BrGlamorousLabelLook new fontSize: 12);
		text: string asRopedText;
		background: BrGlamorousColors lightBorderColor;
		margin: (BlInsets left: 5);
		padding:
			(BlInsets
				top: 5
				left: 0
				bottom: 0
				right: 0).
	^ element
]

{ #category : #initialization }
GtCoderPrintStringAttribute >> initialize [
	super initialize.
	self beAppend
]

{ #category : #accessing }
GtCoderPrintStringAttribute >> string [
	^ string
]

{ #category : #accessing }
GtCoderPrintStringAttribute >> string: aString [
	string := aString
]
