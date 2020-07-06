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
		label: 'Fit It';
		look:
			BrGlamorousButtonWithIconLook
				+
					(look := BrGlamorousWithDropdownLook
						handle: [ BrButton new
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousIcons empty;
								yourself ]
						content: [ BrCoderContextMenuContent new
								items: (fixItActions collect: [ :each | each menuAction ]) ]);
		icon: BrGlamorousIcons more asElement;
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
