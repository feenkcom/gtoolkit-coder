Class {
	#name : #GtClassCoderEditableLabel,
	#superclass : #BrEditor,
	#instVars : [
		'acceptedAction',
		'cancelledAction',
		'deletedAction'
	],
	#category : #'GToolkit-Coder-UI - Class'
}

{ #category : #'api - editor' }
GtClassCoderEditableLabel >> acceptEdition [

	self isEditable
		ifTrue: [ self onEditionAccepted: self text ].

	self switchToLabel
]

{ #category : #'api - editor' }
GtClassCoderEditableLabel >> cancelEdition [

	self isEditable
		ifTrue: [ self onEditionCancelled ].

	self switchToLabel
]

{ #category : #'api - label' }
GtClassCoderEditableLabel >> deleteLabel [
	self isReadOnly
		ifFalse: [ ^ self ].
		
	self isAttachedToSceneGraph
		ifFalse: [ ^ self ].

	self onLabelDeleted
]

{ #category : #initialization }
GtClassCoderEditableLabel >> initialize [
	| anEditorLook |
	super initialize.
	
	acceptedAction := [ :aText |  ].
	cancelledAction := [  ].
	deletedAction := [  ].
	
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
		geometry: (BlRectangle cornerRadius: 4).

	self styler: GtCoderInstanceVariableStyler new.
	self inputFilter: BrTextEditorAlphaNumericInputFilter new.

	self when: BlClickEvent do: [ :anEvent |
		anEvent currentTarget dispatchEvent: (BrSelectedWish selected: true) ].

	self when: BlDoubleClickEvent
		do: [ :anEvent | anEvent currentTarget switchToEditor ].

	self when: BlBlurEvent
		do: [ :anEvent | anEvent currentTarget acceptEdition ].
	
	self switchToLabel
]

{ #category : #hooks }
GtClassCoderEditableLabel >> onEditionAccepted: aText [
	acceptedAction cull: aText cull: self
]

{ #category : #hooks }
GtClassCoderEditableLabel >> onEditionCancelled [
	cancelledAction cull: self
]

{ #category : #hooks }
GtClassCoderEditableLabel >> onLabelDeleted [
	deletedAction cull: self
]

{ #category : #'private - mode' }
GtClassCoderEditableLabel >> switchToEditor [
	self selecter all select.
	
	self beMode: (BrTextEditorEditableMode new withInteractions: {
		BlKeyCombination return -> [ :anEditor :anEvent | anEvent currentTarget acceptEdition ].
		BlKeyCombination escape -> [ :anEditor :anEvent | anEvent currentTarget cancelEdition ]
	})
]

{ #category : #'private - mode' }
GtClassCoderEditableLabel >> switchToLabel [
	self deselecter
		all;
		deselect.

	self beMode: (BrTextEditorReadonlyWithoutSelectionMode new withInteractions: {
		BlKeyCombination backspace -> [ :anEditor :anEvent | anEvent currentTarget deleteLabel ].
		BlKeyCombination escape -> [ :anEditor :anEvent | anEvent currentTarget looseFocus ]
	}).
]

{ #category : #'api - editor' }
GtClassCoderEditableLabel >> whenAccepted: aBlock [
	acceptedAction := aBlock
]

{ #category : #'api - editor' }
GtClassCoderEditableLabel >> whenCancelled: aBlock [
	cancelledAction := aBlock
]

{ #category : #'api - label' }
GtClassCoderEditableLabel >> whenDeleted: aBlock [
	deletedAction := aBlock
]
