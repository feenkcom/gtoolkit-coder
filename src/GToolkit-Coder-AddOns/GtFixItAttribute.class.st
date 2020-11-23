Class {
	#name : #GtFixItAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'fixItActionsBlock'
	],
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #accessing }
GtFixItAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	"Return an element that should affect (either append or replace) a provided text piece"
	<return: #SequenceableCollection of: #BlElement>

	^ BrButton new
		beTiny;
		label: 'Fix it';
		look: BrGlamorousButtonWithIconLook - BrGlamorousButtonExteriorLook +
			(BrGlamorousWithDropdownLook
				handle: [
					BrButton new
						beTiny;
						look: BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook
								- BrGlamorousButtonExteriorLook;
						icon: BrGlamorousVectorIcons repair;
						yourself ]
				content: [
					GtCoderContextMenuContent new
						editorElement: anEditorElement;
						items: (fixItActionsBlock value collect: [ :each | each menuAction ]) ]);
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
