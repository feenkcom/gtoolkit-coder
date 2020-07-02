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
	^ BrButton new
		label: 'Fit It';
		look:
			BrGlamorousButtonWithIconLook
				+
					(BrGlamorousWithDropdownLook
						handle: [ BrButton new
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousIcons empty;
								yourself ]
						content: [ BlElement new
								size: 400 @ 200;
								addChild:
									(BrSimpleList new
										matchParent;
										stencil: [ :each | each asElement ];
										items: fixItActions) ]);
		icon: BrGlamorousIcons more asElement;
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
