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
GtFixItAttribute >> description: aBlockReturningBlText [
	descriptionBlock := aBlockReturningBlText
]

{ #category : #accessing }
GtFixItAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	| button |
	button := GtFixItButton new.
	button beTinySize.
	button label: (label ifNil: [ 'Fix it' ]).
	button
		aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude
				+ (BrGlamorousWithDropdownAptitude
						handle: [ BrButton new
								beTinySize;
								aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
										- BrGlamorousButtonExteriorAptitude;
								icon: BrGlamorousVectorIcons repair;
								yourself ]
						content: [ self dropDownElementFor: anEditorElement ]).
	button icon: BrGlamorousVectorIcons repair.
	hoverMarker
		ifNotNil: [ button
				when: BlMouseEnterEvent
				do: [ :anEvent | 
					anEditorElement editor text
						findAttribute: hoverMarker
						indicesDo: [ :aHighlightStart :aHighlightEnd | 
							(anEditorElement text from: aHighlightStart to: aHighlightEnd)
								attribute: hoverAttribute ] ].
			button
				when: BlMouseLeaveEvent
				do: [ :anEvent | anEditorElement text clearAttributes: [ :each | each == hoverAttribute ] ] ].
	^ button
]

{ #category : #accessing }
GtFixItAttribute >> dropDownElementFor: anEditorElement [
	| pane label text menu menuItems |
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
			label := BrEditor new
					vFitContent;
					aptitude: BrGlamorousRegularEditorAptitude new glamorousCodeSmallSize;
					text: text.
			menuItems isEmpty
				ifTrue: [ label width: 200 ]
				ifFalse: [ label hMatchParent ].
			pane addChild: label ].
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
