Class {
	#name : #GtSourceCoderErrorAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'string',
		'openOnFirstShow',
		'clickAction'
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
GtSourceCoderErrorAttribute >> buildPopupIn: anEditorElement aptitude: aptitude [
	| pane text textElement |
	pane := BrVerticalPane new.
	pane id: GtSourceCoderErrorContentElementId.
	pane matchParent.
	string lines
		do: [ :line | 
			text := line asRopedText
					glamorousCodeSmallSize.
			textElement := BlTextElement new.
			textElement text: text.
			textElement padding: (BlInsets all: 10).
			textElement beFocusable.
			textElement
				when: BlClickEvent
				do: [ :event | 
					event currentTarget fireEvent: BrDropdownHideWish new.
					clickAction cull: anEditorElement cull: aptitude ].
			{BlKeyCombination escape.
				BlKeyCombination enter.
				BlKeyCombination backspace}
				do: [ :each | 
					textElement
						addShortcut: (BlShortcutWithAction new
								combination: each;
								repeatable: false;
								action: [ :aShortcutEvent :aShortcutAction | 
									aShortcutEvent currentTarget fireEvent: BrDropdownHideWish new.
									anEditorElement requestFocus ]) ].
			textElement enqueueTask: [ textElement requestFocus ] asBlTask.
			pane addChild: textElement ].
	^ pane
]

{ #category : #accessing }
GtSourceCoderErrorAttribute >> clickAction [
	^ clickAction
]

{ #category : #accessing }
GtSourceCoderErrorAttribute >> clickAction: aBlock [
	clickAction := aBlock
]

{ #category : #accessing }
GtSourceCoderErrorAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	| button aptitude |
	button := self errorButton.
	button id: GtSourceCoderErrorButtonElementId.
	button
		addAptitude: (aptitude := BrGlamorousWithExplicitDropdownAptitude
					handle: [ self errorButton ]
					content: [ self buildPopupIn: anEditorElement aptitude: aptitude ]
					containerDo: [ :aMenuContainer | aMenuContainer border: (BlBorder paint: BrGlamorousColors errorBackgroundColor) ]).
	openOnFirstShow
		ifTrue: [ button
				enqueueTask: [ openOnFirstShow := false.
					button dispatchEvent: BrDropdownShowWish new ] asBlTask ].

	^ button
]

{ #category : #accessing }
GtSourceCoderErrorAttribute >> errorButton [
	^ BrButton new
		background: BrGlamorousColors errorBackgroundColor;
		size: 16 @ 16;
		border: (BlBorder paint: Color transparent width: 2);
		geometry: BlEllipseGeometry new;
		yourself
]

{ #category : #'initialize-release' }
GtSourceCoderErrorAttribute >> for: aString [
	string := aString
]

{ #category : #accessing }
GtSourceCoderErrorAttribute >> initialize [
	super initialize.
	openOnFirstShow := true.
	clickAction := [ :textElement :dropDownAptitude |  ]
]

{ #category : #accessing }
GtSourceCoderErrorAttribute >> openOnFirstShow [
	^ openOnFirstShow
]

{ #category : #accessing }
GtSourceCoderErrorAttribute >> openOnFirstShow: aBoolean [
	openOnFirstShow := aBoolean
]
