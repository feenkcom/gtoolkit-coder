Class {
	#name : #GtFixItAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'fixItActionsBlock'
	],
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #accessing }
GtFixItAttribute >> affect: aTBrTextEditorTextualPiece in: anEditorElement [
	| look |
	^ BrButton new
		beTiny;
		label: 'Fix it';
		look:
			BrGlamorousButtonWithIconLook - BrGlamorousButtonExteriorLook
				+
					(look := BrGlamorousWithDropdownLook
						handle: [ BrButton new
								beTiny;
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousVectorIcons repair;
								yourself ]
						content: [ GtCoderContextMenuContent new
								editorElement: anEditorElement;
								items: (fixItActionsBlock value collect: [ :each | each menuAction ]) ]);
		icon: BrGlamorousVectorIcons repair;
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
