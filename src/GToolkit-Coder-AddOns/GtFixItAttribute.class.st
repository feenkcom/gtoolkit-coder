Class {
	#name : #GtFixItAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'fixItActionsBlock'
	],
	#category : 'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #accessing }
GtFixItAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #SequenceableCollection of: #BlElement>

	^ GtFixItButton new
		beTinySize;
		label: 'Fix it';
		aptitude:
			BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude
				+
					(BrGlamorousWithDropdownAptitude
						handle: [ BrButton new
								beTinySize;
								aptitude:
									BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
										- BrGlamorousButtonExteriorAptitude;
								icon: BrGlamorousVectorIcons repair;
								yourself ]
						content: [ GtCoderContextMenuContent new
								editorElement: anEditorElement;
								items: ((fixItActionsBlock value groupedBy: [ :eachFixitAction | eachFixitAction id ]) values
									flatCollect: [ :fixitActionsPerId | fixitActionsPerId collectWithIndex: [ :eachFixItAction :eachIndex | eachFixItAction menuActionWithIndex: eachIndex ] ]) ]);
		icon: BrGlamorousVectorIcons repair;
		yourself
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
