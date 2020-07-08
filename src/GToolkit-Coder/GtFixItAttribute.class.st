Class {
	#name : #GtFixItAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'fixItActions'
	],
	#category : #'GToolkit-Coder-FixIt'
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
						content: [ BrCoderContextMenuContent new
								items: (fixItActions collect: [ :each | each menuAction ]) ]);
		icon: BrGlamorousVectorIcons repair;
		when: BrContextMenuHideWish do: [ look hide ];
		yourself
]

{ #category : #initialization }
GtFixItAttribute >> fixItActions: aCollection [
	fixItActions := aCollection
]

{ #category : #accessing }
GtFixItAttribute >> initialize [
	super initialize.
	self beAppend
]
