Class {
	#name : #GtFixItAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'fixItActionsBlock'
	],
	#category : #'GToolkit-Coder-FixIt'
}

{ #category : #accessing }
GtFixItAttribute >> affect: aTBrTextEditorTextualPiece in: anEditorElement [
	| look |
	^ BrButton new
		beTiny;
		label: 'Fix It';
		look:
			BrGlamorousButtonWithIconLook - BrGlamorousButtonExteriorLook
				+
					(look := BrGlamorousWithDropdownLook
						handle: [ BrButton new
								beTiny;
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousIcons hamburger;
								yourself ]
						content: [ BrCoderContextMenuContent new
								items: (fixItActionsBlock value collect: [ :each | each menuAction ]) ]);
		icon: BrGlamorousIcons hamburger;
		when: BrContextMenuHideWish do: [ look hide ];
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
