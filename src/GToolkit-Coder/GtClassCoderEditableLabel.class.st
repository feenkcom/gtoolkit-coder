Class {
	#name : #GtClassCoderEditableLabel,
	#superclass : #BrEditor,
	#instVars : [
		'acceptedAction'
	],
	#category : #'GToolkit-Coder-UI - Class'
}

{ #category : #'api - editor' }
GtClassCoderEditableLabel >> acceptEdition [
	self deselecter
		all;
		deselect.

	self beReadOnlyWithoutSelection.
		
	self onEditionAccepted: self text
]

{ #category : #initialization }
GtClassCoderEditableLabel >> initialize [
	| anEditorLook |
	super initialize.
	
	acceptedAction := [ :aText |  ].
	
	anEditorLook := BrGlamorousRegularEditorLook new.

	self
		look: anEditorLook + (BrInteractiveCommonLook new
			default: [ :aWidget |
				aWidget background: BrGlamorousColors neutralBackgroundColor.
				aWidget border: BlBorder empty.
				anEditorLook foreground: Color veryDarkGray ];
			when: (BrInteractionState focused and: BrEditorModeState editable)
				style: [ :aWidget |
					aWidget background: Color white.
					aWidget border: (BlBorder paint: BrGlamorousColors focusedEditorBorderColor width: 1)
				];
			when: (BrInteractionState focused and: BrEditorModeState readOnly)
				style: [ :aWidget |
					aWidget background: BrGlamorousColors focusedEditorBorderColor.
					anEditorLook foreground: Color white ]);
		fitContent;
		beReadOnlyWithoutSelection;
		geometry: (BlRectangle cornerRadius: 4).

	self styler: GtCoderInstanceVariableStyler new.
	self inputFilter: BrTextEditorAlphaNumericInputFilter new.

	self when: BlClickEvent do: [ :anEvent |
		anEvent currentTarget dispatchEvent: (BrSelectedWish selected: true) ].

	self when: BlDoubleClickEvent
		do: [ :anEvent |
			anEvent currentTarget beEditable.
			anEvent currentTarget selecter all select ].
	self when: BlBlurEvent
		do: [ :anEvent | anEvent currentTarget acceptEdition ]
]

{ #category : #hooks }
GtClassCoderEditableLabel >> onEditionAccepted: aText [
	acceptedAction value: aText
]

{ #category : #'api - editor' }
GtClassCoderEditableLabel >> whenAccepted: aBlock [
	acceptedAction := aBlock
]
