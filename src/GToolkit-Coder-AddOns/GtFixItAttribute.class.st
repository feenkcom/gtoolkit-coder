Class {
	#name : #GtFixItAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'fixItActionsBlock',
		'descriptionBlock',
		'hoverMarker',
		'hoverAttribute',
		'label'
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
GtFixItAttribute >> description: aBlockReturningBlText [
	descriptionBlock := aBlockReturningBlText
]

{ #category : #accessing }
GtFixItAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	| button dropDownAptitude |
	button := GtFixItButton new.
	button beTinySize.
	button label: (label ifNil: [ 'Fix it' ]).
	dropDownAptitude := BrGlamorousWithDropdownAptitude
			handle: [ | dropdownButton |
				dropdownButton := BrButton new.
				dropdownButton beTinySize.
				dropdownButton
					aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
							- BrGlamorousButtonExteriorAptitude.
				dropdownButton icon: BrGlamorousVectorIcons repair.
				self addHoveringStylingFor: anEditorElement to: dropdownButton.
				dropdownButton ]
			content: [ | element |
				element := self dropDownElementFor: anEditorElement.
				self addHoveringStylingFor: anEditorElement to: element.
				element ].
	button
		aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude
				+ dropDownAptitude.
	button userData at: #fixItAttribute put: self.
	button userData at: #dropDownAptitude put: dropDownAptitude.
	button icon: BrGlamorousVectorIcons repair.
	self addHoveringStylingFor: anEditorElement to: button.
	^ button
]

{ #category : #accessing }
GtFixItAttribute >> dropDownElementFor: anEditorElement [
	| pane labelText text menu menuItems |
	pane := BrVerticalPane new.
	pane fitContent.
	menuItems := (fixItActionsBlock value
			groupedBy: [ :eachFixitAction | eachFixitAction id ]) values
			flatCollect: [ :fixitActionsPerId | 
				fixitActionsPerId
					collectWithIndex: [ :eachFixItAction :eachIndex | eachFixItAction menuActionWithIndex: eachIndex ] ].
	descriptionBlock
		ifNotNil: [ text := (descriptionBlock cull: anEditorElement) asRopedText
					foreground: BrGlamorousColors disabledButtonTextColor.
			labelText := BrEditor new
					vFitContent;
					aptitude: BrGlamorousRegularEditorAptitude new glamorousCodeSmallSize;
					text: text.
			menuItems isEmpty
				ifTrue: [ labelText width: 200 ]
				ifFalse: [ labelText hMatchParent ].
			pane addChild: labelText ].
	menu := GtCoderContextMenuContent new
			editorElement: anEditorElement;
			items: menuItems.
	pane addChild: menu.
	^ pane
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

{ #category : #accessing }
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
