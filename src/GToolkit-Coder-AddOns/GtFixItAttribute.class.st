Class {
	#name : #GtFixItAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'fixItActionsBlock',
		'descriptionBlock'
	],
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #accessing }
GtFixItAttribute >> description: aBlockReturningBlText [
	descriptionBlock := aBlockReturningBlText
]

{ #category : #accessing }
GtFixItAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"

	<return: #SequenceableCollection of: #BlElement>
	^ GtFixItButton new
		beTinySize;
		label: 'Fix it';
		aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude
				+ (BrGlamorousWithDropdownAptitude
						handle: [ BrButton new
								beTinySize;
								aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
										- BrGlamorousButtonExteriorAptitude;
								icon: BrGlamorousVectorIcons repair;
								yourself ]
						content: [ self dropDownElementFor: anEditorElement ]);
		icon: BrGlamorousVectorIcons repair;
		yourself
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
GtFixItAttribute >> initialize [
	super initialize.

	self beAppend
]
