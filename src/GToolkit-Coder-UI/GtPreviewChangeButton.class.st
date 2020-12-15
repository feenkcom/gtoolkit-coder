Class {
	#name : #GtPreviewChangeButton,
	#superclass : #BrButton,
	#instVars : [
		'changeAction',
		'changeStencil'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #ui }
GtPreviewChangeButton >> buildDropDownElement [
	| element unloadButton |
	element := BrVerticalPane new
		hFitContent;
		alignCenterLeft;
		vFitContent.
	element addChild: changeStencil asElement.
	unloadButton := BrButton new
		icon: self icon;
		beSmallSize;
		requestFocus;
		look: BrGlamorousButtonWithIconLook new;
		label: self label;
		margin:
			(BlInsets
				top: 0
				left: 10
				bottom: 10
				right: 0);
		action: [ :aButtonElement :aButtonModel :anEvent |
			changeAction cull: aButtonElement cull: aButtonModel cull: anEvent.
			aButtonElement fireEvent: BrDropdownHideWish new ];
		yourself.
	element addChild: unloadButton.
	^ element
]

{ #category : #accessing }
GtPreviewChangeButton >> changeAction [
	^ changeAction
]

{ #category : #accessing }
GtPreviewChangeButton >> changeAction: aBlock [
	changeAction := aBlock
]

{ #category : #accessing }
GtPreviewChangeButton >> changeStencil [
	^ changeStencil
]

{ #category : #accessing }
GtPreviewChangeButton >> changeStencil: aStencil [
	changeStencil := aStencil asStencil
]

{ #category : #ui }
GtPreviewChangeButton >> initialize [
	super initialize.

	self margin: (BlInsets left: 5).
	self beTinySize.

	self look: BrGlamorousButtonWithIconLook new +
		(BrGlamorousWithDropdownLook
			handle: [
				BrButton new
					icon: BrGlamorousIcons empty;
					beTinySize;
					look: BrGlamorousButtonRectangularLook new + BrGlamorousButtonIconLook new ]
			content: [ self buildDropDownElement ])
]
