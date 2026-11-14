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

{ #category : #building }
GtDiffElementWithLabelStencil >> create [
	^ self createDiffContainer asScrollableElement
]

{ #category : #building }
GtDiffElementWithLabelStencil >> createDiffContainer [
	^ BrVerticalPane new
		hMatchParent;
		vFitContentLimited;
		addChild: self createPanesDiffElement;
		yourself
]

{ #category : #building }
GtDiffElementWithLabelStencil >> createPanesDiffElement [
	| diff |
	diff := (GtDiffElement onChange: self change)
			aptitude: GtDiffFlatAptitude;
			vFitContentLimited;
			beSmallSize;
			fromLabel: self fromLabelText;
			toLabel: self toLabelText;
			moveButtonsToBottom.
	leftStyler ifNotNil: [ diff leftStyler: leftStyler ].
	rightStyler ifNotNil: [ diff rightStyler: rightStyler ].
	self shouldHideDiff ifTrue: [ diff hideDiff ].
	^ diff
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
