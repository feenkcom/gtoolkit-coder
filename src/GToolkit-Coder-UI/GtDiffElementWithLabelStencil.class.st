Class {
	#name : #GtDiffElementWithLabelStencil,
	#superclass : #BrStencil,
	#instVars : [
		'fromLabelText',
		'toLabelText',
		'shouldHideDiff',
		'change',
		'leftStyler',
		'rightStyler'
	],
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #accessing }
GtDiffElementWithLabelStencil >> change [
	^ change
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> change: aGtCompositeDiffChange [
	change := aGtCompositeDiffChange
]

{ #category : #'api - instantiation' }
GtDiffElementWithLabelStencil >> create [
	| headerElement diffContainer |
	
	headerElement := BrHorizontalPane new
		hMatchParent;
		vFitContent.

	headerElement 
		addChild: self createFromLabel;
		addChild: self createToLabel.
	
	diffContainer := self createDiffContainer.
	
	^ BrVerticalPane new
	 	matchParent;
	 	addChild: headerElement;
	 	addChild: diffContainer asScrollableElement
]

{ #category : #'api - instantiation' }
GtDiffElementWithLabelStencil >> createDiffContainer [
	| diffContainer |
	diffContainer := BrVerticalPane new
		hMatchParent;
		vFitContentLimited.

	self shouldHideDiff ifFalse: [
		diffContainer addChild: self createPanesDiffElement ].
	
	^ diffContainer
]

{ #category : #building }
GtDiffElementWithLabelStencil >> createFromLabel [
	^ BrLabel new
		margin: (BlInsets left: 6);
		aptitude: BrGlamorousLabelAptitude;
		text: (self fromLabelText asRopedText glamorousCodeSmallSize
				foreground: BrGlamorousColors defaultButtonTextColor);
		hMatchParent
]

{ #category : #private }
GtDiffElementWithLabelStencil >> createPanesDiffElement [
	| diffWrapper diff |
	diffWrapper := BrVerticalPane new
			hMatchParent;
			vFitContentLimited.
	diff := (GtDiffElement onChange: self change)
			aptitude: GtDiffFlatAptitude;
			vFitContentLimited;
			beSmallSize;
			moveButtonsToBottom.
	leftStyler ifNotNil: [ diff leftStyler: leftStyler ].
	rightStyler ifNotNil: [ diff rightStyler: rightStyler ].
	diffWrapper addChild: diff.
	^ diffWrapper
]

{ #category : #building }
GtDiffElementWithLabelStencil >> createToLabel [
	^ BrLabel new
		margin: (BlInsets left: 31);
		aptitude: BrGlamorousLabelAptitude;
		text: (self toLabelText asRopedText glamorousCodeSmallSize
				foreground: BrGlamorousColors defaultButtonTextColor);
		hMatchParent
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> fromLabelText [
	^ fromLabelText
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> fromLabelText: aString [

	fromLabelText := aString
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> hideDiff [
	shouldHideDiff := true
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> leftStyler [
	^ leftStyler
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> leftStyler: aStyler [
	leftStyler := aStyler
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> rightStyler [
	^ rightStyler
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> rightStyler: aStyler [
	rightStyler := aStyler
]

{ #category : #testing }
GtDiffElementWithLabelStencil >> shouldHideDiff [
	^ shouldHideDiff ifNil: [ false ]
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> shouldHideDiff: anObject [

	shouldHideDiff := anObject
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> styler [
	^ leftStyler
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> styler: aStyler [
	self
		leftStyler: aStyler;
		rightStyler: aStyler
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> toLabelText [
	^ toLabelText
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> toLabelText: aString [

	toLabelText := aString
]
