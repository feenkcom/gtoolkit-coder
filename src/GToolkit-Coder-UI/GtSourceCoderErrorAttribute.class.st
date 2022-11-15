Class {
	#name : #GtSourceCoderErrorAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'string',
		'openOnFirstShow'
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
	| text button aptitude |
	button := self errorButton.
	button
		addAptitude: (aptitude := BrGlamorousWithDropdownAptitude
					handle: [ self errorButton ]
					content: [ text := string asRopedText
								medium;
								glamorousCodeFontAndSmallSize.
						BlTextElement new
							text: text;
							background: BrGlamorousColors errorBackgroundColor;
							padding: (BlInsets all: 10);
							yourself ]
					aptitudeDo: [ :look | 
						look
							allActorsDepthFirstDo: [ :each | 
								(each isKindOf: BrGlamorousAnchoredAptitude)
									ifTrue: [ each
											addChangeProperty: #(widget border)
											with: [ BlBorder paint: BrGlamorousColors errorBackgroundColor asBlPaint width: 1 ] ] ].
						look background: BrGlamorousColors errorBackgroundColor ]).
	openOnFirstShow ifTrue: [ button enqueueTask: [ aptitude show ] asBlTask ].

	^ button
]

{ #category : #accessing }
GtSourceCoderErrorAttribute >> errorButton [
	^ BrButton new
		aptitude: (BrInteractiveCommonAptitude new
				default: [ :aWidget | aWidget background: BrGlamorousColors errorBackgroundColor ]);
		size: 8 @ 8;
		geometry: BlEllipseGeometry new;
		padding: (BlInsets left: 2 right: 2);
		yourself
]

{ #category : #'initialize-release' }
GtSourceCoderErrorAttribute >> for: aString [
	string := aString
]

{ #category : #accessing }
GtSourceCoderErrorAttribute >> initialize [
	super initialize.
	openOnFirstShow := true
]

{ #category : #accessing }
GtSourceCoderErrorAttribute >> openOnFirstShow [
	^ openOnFirstShow
]

{ #category : #accessing }
GtSourceCoderErrorAttribute >> openOnFirstShow: aBoolean [
	openOnFirstShow := aBoolean
]
