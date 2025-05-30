Class {
	#name : #GtFixItAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'fixItActionsBlock',
		'descriptionBlock',
		'hoverMarker',
		'hoverAttribute',
		'label',
		'elementId'
	],
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #accessing }
GtFixItAttribute >> addHoveringStylingFor: anEditorElement to: anElement [
	hoverMarker ifNil: [ ^ self ].
	anElement
		when: BlMouseEnterEvent
		do: [ :anEvent | 
			anEditorElement editor text
				findAttribute: hoverMarker
				indicesDo: [ :aHighlightStart :aHighlightEnd | 
					(anEditorElement text from: aHighlightStart to: aHighlightEnd)
						attribute: hoverAttribute ] ].
	anElement
		when: BlMouseLeaveEvent
		do: [ :anEvent | anEditorElement text clearAttributes: [ :each | each == hoverAttribute ] ]
]

{ #category : #accessing }
GtFixItAttribute >> computeDescriptionTextInEditorElement: anEditorElement forFixItActions: aCollectionOfFixItActions [ 
	| text |
	
	text := (descriptionBlock 
			cull: anEditorElement 
			cull: aCollectionOfFixItActions) asRopedText
		foreground: BrGlamorousColors disabledButtonTextColor.
		
	^ BrEditor new
		fitContent;
		aptitude: BrGlamorousRegularEditorAptitude new 
			glamorousCodeSmallSize;
		text: text.
]

{ #category : #accessing }
GtFixItAttribute >> computeMenuItemsForFixItActions: aCollectionOfFixItActions [
	| actionsGroupedById |
	actionsGroupedById := aCollectionOfFixItActions
		groupedBy: [ :eachFixitAction | eachFixitAction id ].
		
	^ actionsGroupedById values
		flatCollect: [ :fixitActionsPerId | 
			fixitActionsPerId collectWithIndex: [ :eachFixItAction :eachIndex | 
				eachFixItAction menuActionWithIndex: eachIndex ] ]
]

{ #category : #accessing }
GtFixItAttribute >> description: aBlockReturningBlText [
	descriptionBlock := aBlockReturningBlText
]

{ #category : #accessing }
GtFixItAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	| button dropDownAptitude |
	button := GtFixItButton new.
	elementId ifNotNil: [ button id: elementId ].
	button beTinySize.
	button label: (label ifNil: [ 'Fix it' ]).

	dropDownAptitude := BrGlamorousWithExplicitDropdownAptitude
			handle: [ | dropdownButton |
				dropdownButton := BrButton new.
				dropdownButton beTinySize.
				dropdownButton
					aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude2
							- BrGlamorousButtonExteriorAptitude.
				dropdownButton icon: BrGlamorousVectorIcons repair.
				self addHoveringStylingFor: anEditorElement to: dropdownButton.
				dropdownButton ]
			content: [ | element |
				element := self dropDownElementFor: anEditorElement.
				self addHoveringStylingFor: anEditorElement to: element.
				element ].

	dropDownAptitude withGainFocusOnShow.
				
	button
		aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude - BrGlamorousButtonWithLabelTooltipAptitude2;
		addAptitude: dropDownAptitude;
		addAptitude: (BrGlamorousWithExplicitTooltipAptitude text: (label ifNil: [ 'Fix it' ]) shortcut: BlKeyCombination primaryT).
	button userData at: #fixItAttribute put: self.
	button userData at: #dropDownAptitude put: dropDownAptitude.
	button icon: BrGlamorousVectorIcons repair.

	self addHoveringStylingFor: anEditorElement to: button.
	^ button
]

{ #category : #accessing }
GtFixItAttribute >> dropDownElementFor: anEditorElement [
	| pane menuElement computedFixItActions menuItems |
	computedFixItActions := fixItActionsBlock value.
	menuItems := self computeMenuItemsForFixItActions: computedFixItActions.

	pane := BrVerticalPane new.
	pane fitContent.

	descriptionBlock
		ifNotNil: [ | labelText |
			labelText := self
					computeDescriptionTextInEditorElement: anEditorElement
					forFixItActions: computedFixItActions.

			pane addChild: labelText ].

	menuItems ifNotEmpty: [
		menuElement := GtCoderContextMenuContent new
				beFocusable;
				editorElement: anEditorElement;
				items: menuItems;
				addShortcut: (BlShortcutWithAction new
					combination: BlKeyCombination enter;
					name: 'Perform fix';
					description: 'Perform a fix-it action';
					action: [ :aShortcutEvent :aShortcut | 
							aShortcutEvent consumed: true.
							menuElement selectedItemDo: [ :eachGtCoderContextMenuAction |
								eachGtCoderContextMenuAction action
									cull: anEditorElement textualCoderViewModel
									cull: anEditorElement
									cull: aShortcutEvent.
								menuElement fireEvent: BrDropdownHideWish new.
								menuElement fireEvent: BrContextMenuHideWish new ] ]).
			
		pane
			when: BrPopoverGainFocusWish
			do: [ :anEvent | 
				menuElement
					requestFocus;
					selectOne: 1 ].

		pane addChild: menuElement ].
	^ pane
]

{ #category : #accessing }
GtFixItAttribute >> elementId [
	^ elementId
]

{ #category : #accessing }
GtFixItAttribute >> elementId: anObject [
	elementId := anObject
]

{ #category : #initialization }
GtFixItAttribute >> fixItActions: aCollection [
	fixItActionsBlock := aCollection
]

{ #category : #accessing }
GtFixItAttribute >> hoverAttribute [
	^ hoverAttribute
]

{ #category : #accessing }
GtFixItAttribute >> hoverAttribute: aTextAttribute [
	hoverAttribute := aTextAttribute
]

{ #category : #accessing }
GtFixItAttribute >> hoverMarker [
	^ hoverMarker
]

{ #category : #accessing }
GtFixItAttribute >> hoverMarker: aTextAttribute [
	hoverMarker := aTextAttribute
]

{ #category : #initialization }
GtFixItAttribute >> initialize [
	super initialize.

	self beAppend
]

{ #category : #accessing }
GtFixItAttribute >> label [
	^ label
]

{ #category : #accessing }
GtFixItAttribute >> label: aString [
	label := aString
]

{ #category : #testing }
GtFixItAttribute >> mayHaveExternalReferences [
	^ true
]
