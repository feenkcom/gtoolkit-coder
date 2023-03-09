Class {
	#name : #GtDiffElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TBrSizeAdjustable',
	#classTraits : 'TBrLayoutResizable classTrait + TBrSizeAdjustable classTrait',
	#instVars : [
		'leftElement',
		'rightElement',
		'syncScrollRanges',
		'outlines',
		'separatorElement',
		'styler',
		'buttonsElement',
		'progressLabel'
	],
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #'instance creation' }
GtDiffElement class >> on: anObject [
	self
		deprecated: 'Please use onDiff: instead.'
		transformWith: '`@receiver on: `@arg' -> '`@receiver onDiff: `@arg'.
	^ self onDiff: anObject
]

{ #category : #'instance creation' }
GtDiffElement class >> onChange: aCompositeDiffChange [
	^ self new
		change: aCompositeDiffChange;
		yourself
]

{ #category : #'instance creation' }
GtDiffElement class >> onDiff: aDiffBuilder [
	^ self new
		diff: aDiffBuilder;
		yourself
]

{ #category : #initialize }
GtDiffElement >> change: aCompositeDiffChange [
	| text |
	text := aCompositeDiffChange from asRopedText glamorousCodeFont.
	aCompositeDiffChange applyAttributesToInput: text.
	leftElement text: text.
	text := aCompositeDiffChange to asRopedText glamorousCodeFont.
	aCompositeDiffChange applyAttributesToOutput: text.
	rightElement text: text.
	syncScrollRanges := GtSyncScrollRanges createFromChange: aCompositeDiffChange.
	self updateOutlines.
	self updateProgressLabel
]

{ #category : #initialize }
GtDiffElement >> diff: aDiffBuilder [
	syncScrollRanges := GtSyncScrollRanges createFromDiff: aDiffBuilder.
	leftElement text: aDiffBuilder previousRopedText.
	rightElement text: aDiffBuilder newRopedText.
	aDiffBuilder newStyler ifNotNil: [ :aStyler | self styler: aStyler ].
	self updateOutlines.
	self updateProgressLabel
]

{ #category : #'event handling' }
GtDiffElement >> drawMeAndChildrenOnSpartaCanvas: aCanvas [
	super drawMeAndChildrenOnSpartaCanvas: aCanvas.
	self paintOnCanvas: aCanvas
]

{ #category : #initialize }
GtDiffElement >> editorLook [
	^ BrGlamorousCodeEditorAptitude
]

{ #category : #accessing }
GtDiffElement >> hideButtons [
	buttonsElement visibility: BlVisibility visible
]

{ #category : #initialize }
GtDiffElement >> initialize [
	| gridLayout |
	super initialize.

	gridLayout := BlGridLayout new columnCount: 3.
	self layout: gridLayout.
	self matchParent.

	self beNormalSize.

	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination builder primary arrowDown build;
				action: [ self scrollNext ]).
	self
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination builder primary arrowUp build;
				action: [ self scrollPrevious ]).

	outlines := Dictionary new.

	buttonsElement := self newButtonsElement.
	buttonsElement id: GtDiffButtonsId.
	buttonsElement visibility: BlVisibility gone.
	buttonsElement
		addChildren: {self newPreviousChangeButton.
				self newProgressLabel.
				self newNextChangeButton}.

	leftElement := self newTextElement
			id: GtDiffOldTextId;
			when: BlElementScrolledEvent do: [ :e | self leftScrolled ].
	leftElement editor
		addEventHandler: (BlEventHandler
				on: BrTextEditorCursorMovedEvent
				do: [ :e | self leftCursorChanged ]);
		addEventHandler: (BlEventHandler
				on: BrTextEditorCursorAddedEvent
				do: [ :e | self leftCursorChanged ]).

	rightElement := self newTextElement
			id: GtDiffNewTextId;
			when: BlElementScrolledEvent do: [ :e | self rightScrolled ].
	rightElement editor
		addEventHandler: (BlEventHandler
				on: BrTextEditorCursorMovedEvent
				do: [ :e | self rightCursorChanged ]);
		addEventHandler: (BlEventHandler
				on: BrTextEditorCursorAddedEvent
				do: [ :e | self rightCursorChanged ]).

	separatorElement := self newSeparatorElement id: GtDiffSeparatorId.

	self
		addChildren: {buttonsElement.
				leftElement.
				separatorElement.
				rightElement}
]

{ #category : #'event handling' }
GtDiffElement >> leftBottomFor: anInteger [
	| range element index |
	range := self leftRange.
	range isEmpty ifTrue: [ ^ leftElement bounds top + leftElement padding top ].
	index := (anInteger max: range first) min: range last.
	element := leftElement children at: index - range first + 1.
	^ (anInteger < range first
		ifTrue: [ element bounds top ]
		ifFalse: [ element bounds bottom ]) + leftElement bounds top max: leftElement bounds top
]

{ #category : #'event handling' }
GtDiffElement >> leftCursorChanged [
	| newPosition leftLine range |
	leftLine := self leftLineForCursor ifNil: [ self leftRange first ].
	range := syncScrollRanges rangeForLeft: leftLine.
	syncScrollRanges selectRange: range.
	newPosition := syncScrollRanges rightLineFor: leftLine.
	(self rightRange includes: newPosition)
		ifFalse: [ rightElement scrollToPosition: newPosition ].
	self updateProgressLabel.
	self invalidate
]

{ #category : #accessing }
GtDiffElement >> leftEditorLook: aLook [
	leftElement aptitude: aLook
]

{ #category : #'event handling' }
GtDiffElement >> leftLineForCursor [
	leftElement editor cursors
		do: [ :each | ^ leftElement text asString lineNumberCorrespondingToIndex: each position + 1 ].
	^ nil
]

{ #category : #private }
GtDiffElement >> leftRange [
	| first |
	first := ((leftElement instVarNamed: 'layoutPositionsRange')
			ifNil: [ 1 ]
			ifNotNil: [ :interval | interval first ]) max: 1.
	^ first to: first + leftElement children size - 1
]

{ #category : #'event handling' }
GtDiffElement >> leftScrolled [
	self updateOutlines
]

{ #category : #accessing }
GtDiffElement >> leftStyler: aStyler [
	leftElement editor styler: aStyler
]

{ #category : #'event handling' }
GtDiffElement >> leftTopFor: anInteger [
	| range element index |
	range := self leftRange.
	range isEmpty ifTrue: [ ^ leftElement bounds top + leftElement padding top ].
	index := (anInteger max: range first) min: range last.
	element := leftElement children at: index - range first + 1.
	^ (anInteger > range last
		ifTrue: [ element bounds bottom ]
		ifFalse: [ element bounds top ]) + leftElement bounds top max: leftElement bounds top
]

{ #category : #accessing }
GtDiffElement >> moveButtonsToBottom [
	buttonsElement removeFromParent.
	buttonsElement margin: (BlInsets top: 5).
	self addChild: buttonsElement.
	self showButtons
]

{ #category : #'event handling' }
GtDiffElement >> moveCursorIn: textEditor toLine: anInteger [
	| string index |
	string := textEditor text asString.
	index := (string intervalOfLine: anInteger) first - 1.
	index < 0
		ifTrue: [ index := anInteger <= 0 ifTrue: [ 0 ] ifFalse: [ string size ] ].
	textEditor editor moveCursorTo: index
]

{ #category : #initialize }
GtDiffElement >> newButtonsElement [
	^ BrHorizontalPane new
		vFitContent;
		hMatchParent;
		margin: (BlInsets bottom: 5);
		alignCenter;
		constraintsDo: [ :c | c grid horizontal span: 3 ]
]

{ #category : #initialize }
GtDiffElement >> newNextChangeButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude;
		fitContent;
		beTinySize;
		margin: (BlInsets left: 5);
		icon: BrGlamorousVectorIcons down;
		label: 'Next change';
		action: [ :aButton | self scrollNext ]
]

{ #category : #initialize }
GtDiffElement >> newPreviousChangeButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude;
		fitContent;
		beTinySize;
		icon: BrGlamorousVectorIcons up;
		label: 'Previous change';
		action: [ :aButton | self scrollPrevious ]
]

{ #category : #initialize }
GtDiffElement >> newProgressLabel [
	^ progressLabel := BrLabel new
			fitContent;
			alignCenter;
			margin: (BlInsets left: 5);
			aptitude: BrGlamorousLabelAptitude
]

{ #category : #initialize }
GtDiffElement >> newSeparatorElement [
	^ BlElement new
		constraintsDo: [ :c |
			c vertical exact: 1.
			c horizontal exact: 0 ]
		yourself
]

{ #category : #initialize }
GtDiffElement >> newTextElement [
	^ BrEditor new
		beReadOnlyWithSelection;
		matchParent;
		aptitude: self editorLook
]

{ #category : #'geometry hooks' }
GtDiffElement >> onExtentChanged [ 
	super onExtentChanged.

	outlines := Dictionary new.
	self updateOutlines
]

{ #category : #'geometry hooks' }
GtDiffElement >> onLayout: aBounds context: aBlElementBoundsUpdateContext [
	super onLayout: aBounds context: aBlElementBoundsUpdateContext.
	
	outlines := Dictionary new.
	self updateOutlines
]

{ #category : #'event handling' }
GtDiffElement >> outlineFor: aSyncScrollRange [
	| leftTop leftBottom rightTop rightBottom vertices leftBounds rightBounds |
	leftTop := self leftTopFor: aSyncScrollRange leftFirst + 1.
	leftBottom := self leftBottomFor: aSyncScrollRange leftLast.
	rightTop := self rightTopFor: aSyncScrollRange rightFirst + 1.
	rightBottom := self rightBottomFor: aSyncScrollRange rightLast.
	leftBounds := leftElement bounds.
	rightBounds := rightElement bounds.
	vertices := OrderedCollection new: 9.
	vertices
		add: leftBounds left @ leftTop;
		add: leftBounds right @ leftTop;
		add: rightBounds left @ rightTop;
		add: rightBounds right @ rightTop;
		add: rightBounds right @ rightBottom;
		add: rightBounds left @ rightBottom;
		add: leftBounds right @ leftBottom;
		add: leftBounds left @ leftBottom;
		add: leftBounds left @ leftTop.
	^ BlPolyline vertices: vertices
]

{ #category : #'event handling' }
GtDiffElement >> paintMeAndChildrenOn: aCompositorPainter offset: anOffset [
	| aCanvas |
	super paintMeAndChildrenOn: aCompositorPainter offset: anOffset.

	aCanvas := aCompositorPainter canvas.

	aCanvas transform
		by: [ :t | t translateBy: anOffset ]
		during: [ self paintOnCanvas: aCanvas ]
]

{ #category : #'event handling' }
GtDiffElement >> paintOnCanvas: aCanvas [
	| stroke selectedStroke fill |
	stroke := aCanvas stroke
			alpha: 0.2;
			paint: Color black;
			width: 1.
	selectedStroke := aCanvas stroke
			alpha: 0.6;
			paint: BrGlamorousColors primaryBorderColor;
			width: 2.
	fill := aCanvas fill
			alpha: 0.2;
			paint: Color yellow.
	^ outlines
		keysAndValuesDo: [ :range :each | 
			fill
				path: (each pathOnSpartaCanvas: aCanvas of: self);
				draw.
			(range isSelected ifTrue: [ selectedStroke ] ifFalse: [ stroke ])
				path: (each pathOnSpartaCanvas: aCanvas of: self);
				draw ]
]

{ #category : #'event handling' }
GtDiffElement >> rightBottomFor: anInteger [
	| range element index |
	range := self rightRange.
	range isEmpty ifTrue: [ ^ rightElement bounds top + rightElement padding top ].
	index := (anInteger max: range first) min: range last.
	element := rightElement children at: index - range first + 1.
	^ (anInteger < range first
		ifTrue: [ element bounds top ]
		ifFalse: [ element bounds bottom ]) + rightElement bounds top
		max: rightElement bounds top
]

{ #category : #'event handling' }
GtDiffElement >> rightCursorChanged [
	| newPosition rightLine range |
	rightLine := self rightLineForCursor ifNil: [ self rightRange first ].
	range := syncScrollRanges rangeForRight: rightLine.
	syncScrollRanges selectRange: range.
	newPosition := syncScrollRanges leftLineFor: rightLine.
	(self leftRange includes: newPosition)
		ifFalse: [ leftElement scrollToPosition: newPosition ].
	self updateProgressLabel.
	self invalidate
]

{ #category : #accessing }
GtDiffElement >> rightEditorLook: aLook [
	rightElement aptitude: aLook
]

{ #category : #'event handling' }
GtDiffElement >> rightLineForCursor [
	rightElement editor cursors
		do: [ :each | ^ rightElement text asString lineNumberCorrespondingToIndex: each position + 1 ].
	^ nil
]

{ #category : #private }
GtDiffElement >> rightRange [
	| first |
	first := ((rightElement instVarNamed: 'layoutPositionsRange')
			ifNil: [ 1 ]
			ifNotNil: [ :interval | interval first ]) max: 1.
	^ first to: first + rightElement children size - 1
]

{ #category : #'event handling' }
GtDiffElement >> rightScrolled [
	self updateOutlines
]

{ #category : #accessing }
GtDiffElement >> rightStyler: aStyler [
	rightElement editor styler: aStyler
]

{ #category : #'event handling' }
GtDiffElement >> rightTopFor: anInteger [
	| range element index |
	range := self rightRange.
	range isEmpty ifTrue: [ ^ rightElement bounds top + rightElement padding top ].
	index := (anInteger max: range first) min: range last.
	element := rightElement children at: index - range first + 1.
	^ (anInteger > range last
		ifTrue: [ element bounds bottom ]
		ifFalse: [ element bounds top ]) + rightElement bounds top
		max: rightElement bounds top
]

{ #category : #'event handling' }
GtDiffElement >> scrollNext [
	| range |
	range := syncScrollRanges selectNext.
	range ifNil: [ ^ self ].
	leftElement scrollToPosition: range leftFirst + 1.
	rightElement scrollToPosition: range rightFirst + 1.
	self updateProgressLabel
]

{ #category : #'event handling' }
GtDiffElement >> scrollPrevious [
	| range |
	range := syncScrollRanges selectPrevious.
	range ifNil: [ ^ self ].
	leftElement scrollToPosition: range leftFirst + 1.
	rightElement scrollToPosition: range rightFirst + 1.
	self updateProgressLabel
]

{ #category : #accessing }
GtDiffElement >> showButtons [
	buttonsElement visibility: BlVisibility visible
]

{ #category : #accessing }
GtDiffElement >> styler [
	^ styler
]

{ #category : #accessing }
GtDiffElement >> styler: anObject [
	styler := anObject.
	styler
		ifNotNil: [ leftElement styler: styler.
			rightElement styler: styler ]
]

{ #category : #'event handling' }
GtDiffElement >> updateOutlines [
	| ranges |
	outlines := Dictionary new.
	ranges := syncScrollRanges
		rangesForLeft: self leftRange
		andRight: self rightRange.
	ranges
		do: [ :each | 
			each isDifference
				ifTrue: [ outlines at: each put: (self outlineFor: each) ] ].
	self invalidate
]

{ #category : #initialize }
GtDiffElement >> updateProgressLabel [
	| progress |
	progress := syncScrollRanges selectedProgress.
	progressLabel
		text: (progress first printString , '/' , progress last printString) asRopedText
				glamorousRegularFont
]
