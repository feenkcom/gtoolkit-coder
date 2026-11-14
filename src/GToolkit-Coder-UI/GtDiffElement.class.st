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
		'progressLabel',
		'deletedLines',
		'insertedLines',
		'leftLabelElement',
		'rightLabelElement',
		'headerSeparatorElement'
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
		scrollNext;
		yourself
]

{ #category : #'instance creation' }
GtDiffElement class >> onChangeWithoutScrolling: aCompositeDiffChange [
	^ self new
		change: aCompositeDiffChange;
		yourself
]

{ #category : #'instance creation' }
GtDiffElement class >> onDiff: aDiffBuilder [
	^ self new
		diff: aDiffBuilder;
		scrollNext;
		yourself
]

{ #category : #'instance creation' }
GtDiffElement class >> onDiffWithoutScrolling: aDiffBuilder [
	^ self new
		diff: aDiffBuilder;
		scrollNext;
		yourself
]

{ #category : #accessing }
GtDiffElement >> change: aCompositeDiffChange [
	| text |
	deletedLines := Set new.
	insertedLines := Set new.
	aCompositeDiffChange
		deletionChangesDo: [ :each | 
			each isEmpty
				ifFalse: [ deletedLines
						addAll: ((aCompositeDiffChange from lineNumberCorrespondingToIndex: each startIndex)
								to: (aCompositeDiffChange from lineNumberCorrespondingToIndex: each stopIndex)) ] ].
	aCompositeDiffChange
		insertionChangesDo: [ :each | 
			each isEmpty
				ifFalse: [ insertedLines
						addAll: ((aCompositeDiffChange to lineNumberCorrespondingToIndex: each startIndex)
								to: (aCompositeDiffChange to lineNumberCorrespondingToIndex: each stopIndex)) ] ].
	text := aCompositeDiffChange from asRopedText glamorousCodeFont.
	aCompositeDiffChange
		deletionChangesDo: [ :each | 
			self
				highlightChange: each
				in: text
				color: (each highlightColorForTheme: self theme) ].
	leftElement text: text.
	text := aCompositeDiffChange to asRopedText glamorousCodeFont.
	aCompositeDiffChange
		insertionChangesDo: [ :each | 
			self
				highlightChange: each
				in: text
				color: (each highlightColorForTheme: self theme) ].
	rightElement text: text.
	syncScrollRanges := GtSyncScrollRanges createFromChange: aCompositeDiffChange.
	self updateOutlines.
	self updateProgressLabel
]

{ #category : #accessing }
GtDiffElement >> diff: aDiffBuilder [
	| leftLine rightLine |
	deletedLines := Set new.
	insertedLines := Set new.
	leftLine := 0.
	rightLine := 0.
	aDiffBuilder
		patchSequenceDoIfMatch: [ :line | 
			leftLine := leftLine + 1.
			rightLine := rightLine + 1 ]
		ifInsert: [ :line | 
			rightLine := rightLine + 1.
			insertedLines add: rightLine ]
		ifRemove: [ :line | 
			leftLine := leftLine + 1.
			deletedLines add: leftLine ].
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
GtDiffElement >> fromLabel [
	^ leftLabelElement text asString
]

{ #category : #accessing }
GtDiffElement >> fromLabel: aText [
	leftLabelElement text: (aText ifNil: [ '' ]) asRopedText glamorousCodeSmallSize.
	self updateLabelsVisibility
]

{ #category : #private }
GtDiffElement >> gutterOutlineFor: aSyncScrollRange [
	| leftX rightX leftTop leftBottom rightTop rightBottom |
	leftX := leftElement bounds inParent inParent right.
	rightX := rightElement bounds inParent inParent left.
	leftTop := self leftTopFor: aSyncScrollRange leftFirst + 1.
	leftBottom := self leftBottomFor: aSyncScrollRange leftLast.
	rightTop := self rightTopFor: aSyncScrollRange rightFirst + 1.
	rightBottom := self rightBottomFor: aSyncScrollRange rightLast.
	^ BlPolylineGeometry
		vertices: {leftX @ leftTop.
				rightX @ rightTop.
				rightX @ rightBottom.
				leftX @ leftBottom.
				leftX @ leftTop}
]

{ #category : #accessing }
GtDiffElement >> hideButtons [
	buttonsElement visibility: BlVisibility visible
]

{ #category : #accessing }
GtDiffElement >> hideDiff [
	{leftElement.
		separatorElement.
		rightElement.
		buttonsElement} do: [ :element | element visibility: BlVisibility gone ].
	outlines := Dictionary new.
	self invalidate
]

{ #category : #private }
GtDiffElement >> highlightChange: aChange in: aText color: aColor [
	aChange isEmpty ifTrue: [ ^ self ].
	aText
		attribute: (GtDiffTextHighlightAttribute paint: aColor)
				beNotOverwritableByStyler
		from: aChange startIndex
		to: aChange stopIndex
]

{ #category : #initialization }
GtDiffElement >> initialize [
	| comparisonElement |
	super initialize.

	self layout: BlLinearLayout vertical.
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
	syncScrollRanges := GtSyncScrollRanges new.
	deletedLines := Set new.
	insertedLines := Set new.

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

	leftLabelElement := self newLabelElement id: GtDiffOldLabelId.
	rightLabelElement := self newLabelElement id: GtDiffNewLabelId.
	headerSeparatorElement := BlElement new
			size: 0 @ 0;
			visibility: BlVisibility gone.
	separatorElement := self newSeparatorElement id: GtDiffSeparatorId.
	{leftLabelElement.
		rightLabelElement.
		leftElement.
		rightElement}
		do: [ :element | 
			element
				constraintsDo: [ :c | 
					c grid horizontal
						weight: 1;
						specAlignment: BlGridAlignment fill ] ].
	comparisonElement := BlElement new
			layout: (BlGridLayout horizontal columnCount: 3);
			constraintsDo: [ :c | 
				c horizontal matchParent.
				c vertical fitContentLimited ];
			addChildren: {leftLabelElement.
					headerSeparatorElement.
					rightLabelElement.
					leftElement.
					separatorElement.
					rightElement}.

	self
		addChildren: {buttonsElement.
				comparisonElement}.
	self updateProgressLabel
]

{ #category : #'event handling' }
GtDiffElement >> leftBottomFor: anInteger [
	| range element index parentBounds |
	range := self leftRange.
	parentBounds := leftElement bounds inParent inParent.
	range isEmpty ifTrue: [ ^ parentBounds top + leftElement padding top ].
	index := (anInteger max: range first) min: range last.
	element := leftElement children at: index - range first + 1.
	^ ((anInteger < range first
		ifTrue: [ element bounds top ]
		ifFalse: [ element bounds bottom ]) + leftElement bounds inParent inParent top
		max: parentBounds top) min: parentBounds bottom
]

{ #category : #private }
GtDiffElement >> leftChangeColorFor: aRange [
	^ (deletedLines anySatisfy: [ :line | aRange includesLeftLine: line ])
		ifTrue: [ self theme diffElement deletedLineBackgroundColor ]
		ifFalse: [ self theme diffElement unchangedSideBackgroundColor ]
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
	first := (leftElement findMinMaxChildLayoutPositions
			ifNil: [ 1 ]
			ifNotNil: [ :interval | interval first ]) max: 1.
	^ first to: first + leftElement children size - 1
]

{ #category : #'event handling' }
GtDiffElement >> leftScrolled [
	self updateOutlines
]

{ #category : #accessing }
GtDiffElement >> leftStyler [
	^ leftElement editor styler
]

{ #category : #accessing }
GtDiffElement >> leftStyler: aStyler [
	leftElement editor styler: aStyler
]

{ #category : #'event handling' }
GtDiffElement >> leftTopFor: anInteger [
	| range element index |
	range := self leftRange.
	range isEmpty
		ifTrue: [ ^ leftElement bounds inParent inParent top + leftElement padding top ].
	index := (anInteger max: range first) min: range last.
	element := leftElement children at: index - range first + 1.
	^ (anInteger > range last
		ifTrue: [ element bounds bottom ]
		ifFalse: [ element bounds top ]) + leftElement bounds inParent inParent top
		max: leftElement bounds inParent inParent top
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

{ #category : #private }
GtDiffElement >> newLabelElement [
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		text: '';
		hMatchParent;
		vFitContent;
		visibility: BlVisibility gone
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

{ #category : #private }
GtDiffElement >> newTextElement [
	^ BrEditor new
		beReadOnlyWithSelection;
		hMatchParent;
		vFitContentLimited;
		background: self theme diffElement editorBackgroundColor;
		aptitude: self editorLook	"border: (BlBorder paint: self theme diffElement editorBorderColor width: 1);
		"
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

{ #category : #hooks }
GtDiffElement >> onThemeChanged [
	super onThemeChanged.
	syncScrollRanges
		ifNotNil: [ self updateLineBackgrounds.
			self invalidate ]
]

{ #category : #'event handling' }
GtDiffElement >> outlineFor: aSyncScrollRange [
	| leftTop leftBottom rightTop rightBottom vertices leftBounds rightBounds |
	leftTop := self leftTopFor: aSyncScrollRange leftFirst + 1.
	leftBottom := self leftBottomFor: aSyncScrollRange leftLast.
	rightTop := self rightTopFor: aSyncScrollRange rightFirst + 1.
	rightBottom := self rightBottomFor: aSyncScrollRange rightLast.
	leftBounds := leftElement bounds inParent inParent.
	rightBounds := rightElement bounds inParent inParent.
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
	^ BlPolylineGeometry vertices: vertices
]

{ #category : #drawing }
GtDiffElement >> paintHorizontalPaddingOf: anEditor from: top to: bottom color: aColor on: aCanvas [
	| bounds fill |
	bottom <= top ifTrue: [ ^ self ].
	bounds := anEditor bounds inParent inParent.
	fill := aCanvas fill paint: aColor.
	{{bounds left @ top.
			(bounds left + anEditor padding left) @ top.
			(bounds left + anEditor padding left) @ bottom.
			bounds left @ bottom.
			bounds left @ top}.
		{(bounds right - anEditor padding right) @ top.
			bounds right @ top.
			bounds right @ bottom.
			(bounds right - anEditor padding right) @ bottom.
			(bounds right - anEditor padding right) @ top}}
		do: [ :vertices | 
			fill
				path: ((BlPolylineGeometry vertices: vertices) pathOnSpartaCanvas: aCanvas of: self);
				draw ]
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

{ #category : #drawing }
GtDiffElement >> paintOnCanvas: aCanvas [
	| stroke selectedStroke fill |
	stroke := aCanvas stroke
			paint: self theme diffElement borderColor;
			width: 1.
	selectedStroke := aCanvas stroke
			paint: self theme diffElement selectedBorderColor;
			width: 1.
	fill := aCanvas fill paint: self theme diffElement connectorBackgroundColor.
	^ outlines
		keysAndValuesDo: [ :range :outline | 
			range isLeftEmpty
				ifFalse: [ self
						paintHorizontalPaddingOf: leftElement
						from: (self leftTopFor: range leftFirst + 1)
						to: (self leftBottomFor: range leftLast)
						color: (self leftChangeColorFor: range)
						on: aCanvas ].
			range isRightEmpty
				ifFalse: [ self
						paintHorizontalPaddingOf: rightElement
						from: (self rightTopFor: range rightFirst + 1)
						to: (self rightBottomFor: range rightLast)
						color: (self rightChangeColorFor: range)
						on: aCanvas ].
			fill
				path: ((self gutterOutlineFor: range) pathOnSpartaCanvas: aCanvas of: self);
				draw.
			(range isSelected ifTrue: [ selectedStroke ] ifFalse: [ stroke ])
				path: (outline pathOnSpartaCanvas: aCanvas of: self);
				draw ]
]

{ #category : #'event handling' }
GtDiffElement >> rightBottomFor: anInteger [
	| range element index parentBounds |
	range := self rightRange.
	parentBounds := rightElement bounds inParent inParent.
	range isEmpty ifTrue: [ ^ parentBounds top + rightElement padding top ].
	index := (anInteger max: range first) min: range last.
	element := rightElement children at: index - range first + 1.
	^ ((anInteger < range first
		ifTrue: [ element bounds top ]
		ifFalse: [ element bounds bottom ])
		+ rightElement bounds inParent inParent top max: parentBounds top)
		min: parentBounds bottom
]

{ #category : #private }
GtDiffElement >> rightChangeColorFor: aRange [
	^ (insertedLines anySatisfy: [ :line | aRange includesRightLine: line ])
		ifTrue: [ self theme diffElement addedLineBackgroundColor ]
		ifFalse: [ self theme diffElement unchangedSideBackgroundColor ]
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
	first := (rightElement findMinMaxChildLayoutPositions
			ifNil: [ 1 ]
			ifNotNil: [ :interval | interval first ]) max: 1.
	^ first to: first + rightElement children size - 1
]

{ #category : #'event handling' }
GtDiffElement >> rightScrolled [
	self updateOutlines
]

{ #category : #accessing }
GtDiffElement >> rightStyler [
	^ rightElement editor styler
]

{ #category : #accessing }
GtDiffElement >> rightStyler: aStyler [
	rightElement editor styler: aStyler
]

{ #category : #'event handling' }
GtDiffElement >> rightTopFor: anInteger [
	| range element index |
	range := self rightRange.
	range isEmpty ifTrue: [ ^ rightElement bounds inParent inParent top + rightElement padding top ].
	index := (anInteger max: range first) min: range last.
	element := rightElement children at: index - range first + 1.
	^ (anInteger > range last
		ifTrue: [ element bounds bottom ]
		ifFalse: [ element bounds top ]) + rightElement bounds inParent inParent top
		max: rightElement bounds inParent inParent top
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

{ #category : #accessing }
GtDiffElement >> toLabel [
	^ rightLabelElement text asString
]

{ #category : #accessing }
GtDiffElement >> toLabel: aText [
	rightLabelElement
		text: (aText ifNil: [ '' ]) asRopedText glamorousCodeSmallSize.
	self updateLabelsVisibility
]

{ #category : #private }
GtDiffElement >> updateLabelsVisibility [
	| visibility |
	visibility := (self fromLabel isEmpty and: [ self toLabel isEmpty ])
			ifTrue: [ BlVisibility gone ]
			ifFalse: [ BlVisibility visible ].
	{leftLabelElement.
		headerSeparatorElement.
		rightLabelElement} do: [ :element | element visibility: visibility ]
]

{ #category : #private }
GtDiffElement >> updateLineBackgrounds [
	| leftVisible rightVisible differences |
	leftElement background: self theme diffElement editorBackgroundColor.
	rightElement background: self theme diffElement editorBackgroundColor.
	leftVisible := self leftRange.
	rightVisible := self rightRange.
	differences := syncScrollRanges ranges select: [ :range | range isDifference ].
	leftElement children
		withIndexDo: [ :child :index | 
			| range |
			range := differences
					detect: [ :each | each includesLeftLine: leftVisible first + index - 1 ]
					ifNone: [ nil ].
			child
				background: (range
						ifNil: [ self theme diffElement editorBackgroundColor ]
						ifNotNil: [ self leftChangeColorFor: range ]) ].
	rightElement children
		withIndexDo: [ :child :index | 
			| range |
			range := differences
					detect: [ :each | each includesRightLine: rightVisible first + index - 1 ]
					ifNone: [ nil ].
			child
				background: (range
						ifNil: [ self theme diffElement editorBackgroundColor ]
						ifNotNil: [ self rightChangeColorFor: range ]) ]
]

{ #category : #private }
GtDiffElement >> updateOutlines [
	| ranges |
	leftElement visibility = BlVisibility gone
		ifTrue: [ outlines := Dictionary new.
			self invalidate.
			^ self ].
	outlines := Dictionary new.
	ranges := syncScrollRanges
			rangesForLeft: self leftRange
			andRight: self rightRange.
	ranges
		do: [ :each | each isDifference ifTrue: [ outlines at: each put: (self outlineFor: each) ] ].
	self updateLineBackgrounds.
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
