Class {
	#name : #GtCoderPrintStringAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'object'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Attributes'
}

{ #category : #'instance creation' }
GtCoderPrintStringAttribute class >> forObject: anObject [
	^ self new
		object: anObject;
		yourself
]

{ #category : #'instance creation' }
GtCoderPrintStringAttribute class >> forString: aString [
	^ self new
		object: aString;
		yourself
]

{ #category : #private }
GtCoderPrintStringAttribute >> actionButtonLook [
	^ BrGlamorousButtonIconAptitude + BrGlamorousButtonLayoutAptitude + (BrStyleCommonAptitude new
		default: [ :aStyle | aStyle geometry: BlCircle new ];
		hovered: [ :aStyle | aStyle background: BrGlamorousColors neutralBackgroundColor darker ];
		pressed: [ :aStyle | aStyle background: BrGlamorousColors neutralBackgroundColor darker darker ])
]

{ #category : #private }
GtCoderPrintStringAttribute >> buildMenuFor: aHamburgerButton fromEditorElement: anEditorElement [

	^ BrVerticalPane new
		fitContent;
		addChildren: { 
			BrButton new
				aptitude: self menuButtonLook;
				label: 'Copy';
				icon: BrGlamorousVectorIcons clipboard;
				beSmallSize;
				hMatchParent;
				alignCenterLeft;
				action: [ :aButtonElement |
					self closeMenuFromElement: aButtonElement.
					self copyFromEditorElement: anEditorElement ].
			BrButton new
				aptitude: self menuButtonLook;
				label: 'Inspect';
				icon: BrGlamorousVectorIcons inspect;
				beSmallSize;
				hMatchParent;
				alignCenterLeft;
				action: [ :aButtonElement |
					self closeMenuFromElement: aButtonElement.
					self spawnFromElement: aHamburgerButton ].
			BrButton new
				aptitude: self menuButtonLook;
				label: 'Insert';
				icon: BrGlamorousVectorIcons accept;
				beSmallSize;
				hMatchParent;
				alignCenterLeft;
				action: [ :aButtonElement |
					self closeMenuFromElement: aButtonElement.
					self insertIntoTheEditorElement: anEditorElement ].
			BrButton new
				aptitude: self menuButtonLook;
				label: 'Remove';
				icon: BrGlamorousVectorIcons close;
				beSmallSize;
				hMatchParent;
				alignCenterLeft;
				action: [ :aButtonElement |
					self closeMenuFromElement: aButtonElement.
					self removeFromEditorElement: anEditorElement ].
		}
]

{ #category : #private }
GtCoderPrintStringAttribute >> buildTooltip [
	^ BrEditor new
		aptitude: BrGlamorousEditorAptitude new glamorousRegularSmallSize;
		fitContentLimited;
		beReadOnlyWithSelection;
		text:
			'Press ' asRopedText, 'ctrl/cmd + c' asRopedText glamorousRoundedBackground, (' to copy this string.', String cr) asRopedText,
			'Press ' asRopedText, 'ctrl/cmd + i' asRopedText glamorousRoundedBackground, (' to inspect the evaluation result.', String cr) asRopedText,
			'Press ' asRopedText, 'enter' asRopedText glamorousRoundedBackground, (' to insert this string into the editor.', String cr) asRopedText,
			'Press ' asRopedText, 'backspace' asRopedText glamorousRoundedBackground, ' to remove this popup.' asRopedText
]

{ #category : #private }
GtCoderPrintStringAttribute >> closeMenuFromElement: anElement [
	anElement fireEvent: BrDropdownHideWish new
]

{ #category : #'private - actions' }
GtCoderPrintStringAttribute >> copyFromEditorElement: anEditorElement [
	Clipboard clipboardText: object printString
]

{ #category : #accessing }
GtCoderPrintStringAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	| hamburgerButton |
	
	hamburgerButton := nil.
	
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new glamorousCodeFont labelDo: [ :aLabel |
			aLabel addAptitude: (BrGlamorousWithTooltipAptitude new contentStencil: [ self buildTooltip ]) ]);
		beTinySize;
		text: object printString;
		background: BrGlamorousColors neutralBackgroundColor;
		margin: (BlInsets top: 0 left: 4 bottom: 0 right: 4);
		padding: (BlInsets top: 2 left: 4 bottom: 2 right: 4);
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		addAptitude: (BrStyleCommonAptitude new
			focused: [ :aStyle | aStyle border: (BlBorder paint: (BrGlamorousColors focusedEditorBorderColor alpha: 0.75) width: 1) ]);
		requestFocus;
		addShortcut: (BlShortcutWithAction new
			combination: BlKeyCombination primaryC;
			action: [ self copyFromEditorElement: anEditorElement ]);
		addShortcut: (BlShortcutWithAction new
			combination: BlKeyCombination primaryI;
			action: [ :aShortcutEvent | self spawnFromElement: aShortcutEvent currentTarget ]);
		addShortcut: (BlShortcutWithAction new
			combination: BlKeyCombination return;
			action: [ self insertIntoTheEditorElement: anEditorElement ]);
		addShortcut: (BlShortcutWithAction new
			combination: BlKeyCombination backspace;
			action: [ self removeFromEditorElement: anEditorElement ]);
		when: BlMouseDownEvent do: [ :anEvent |
			anEvent consumed: true.
			anEvent currentTarget requestFocus ];
		when: BlElementRemovedFromParentEvent do: [ :anEvent |
			anEditorElement requestFocus ];
		addChild: (hamburgerButton := BrButton new
			aptitude: self actionButtonLook + (BrGlamorousWithDropdownAptitude
				handle: [ BrButton new
					aptitude: BrGlamorousButtonIconAptitude + BrGlamorousButtonLayoutAptitude;
					icon: BrGlamorousVectorIcons hamburger;
					beSmallSize;
					exact: 16@16 ]
				content: [ self buildMenuFor: hamburgerButton fromEditorElement: anEditorElement ]);
			icon: BrGlamorousVectorIcons hamburger;
			beTinySize;
			exact: 12@12)
]

{ #category : #initialization }
GtCoderPrintStringAttribute >> initialize [
	super initialize.
	self beAppend
]

{ #category : #'private - actions' }
GtCoderPrintStringAttribute >> insertIntoTheEditorElement: anEditorElement [
	anEditorElement text
		findAttribute: self
		indicesDo: [ :aStart :anEnd |
			| aPrintString |
			
			aPrintString := object printString.
			
			anEditorElement editor inserter
				string: aPrintString;
				at: anEnd;
				insert.

			anEditorElement editor navigator
				moveTo: anEnd + aPrintString size;
				apply.
			
			anEditorElement editor selecter
				from: anEnd
				to: anEnd + aPrintString size;
				select ].
	anEditorElement text removeAttribute: self.
	anEditorElement requestFocus
]

{ #category : #testing }
GtCoderPrintStringAttribute >> isFocusable [
	^ true
]

{ #category : #private }
GtCoderPrintStringAttribute >> menuButtonLook [
	^ (BrGlamorousButtonRectangularAptitude new cornerRadius: 0)
		+ BrGlamorousButtonIconAptitude
		+ BrGlamorousLabelAptitude
		+ BrGlamorousListItemAptitude
]

{ #category : #accessing }
GtCoderPrintStringAttribute >> object: anObject [
	object := anObject
]

{ #category : #'private - actions' }
GtCoderPrintStringAttribute >> removeFromEditorElement: anEditorElement [
	anEditorElement text
		findAttribute: self
		indicesDo: [ :aStart :anEnd |
			anEditorElement editor navigator
				moveTo: anEnd;
				apply ].
	anEditorElement text removeAttribute: self.
	anEditorElement requestFocus
]

{ #category : #'private - actions' }
GtCoderPrintStringAttribute >> spawnFromElement: anElement [
	anElement phlow spawnObject: object
]
