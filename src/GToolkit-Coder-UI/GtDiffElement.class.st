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
		'styler'
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
	self updateOutlines
]

{ #category : #initialize }
GtDiffElement >> diff: aDiffBuilder [
	syncScrollRanges := GtSyncScrollRanges createFromDiff: aDiffBuilder.
	leftElement text: aDiffBuilder previousRopedText.
	rightElement text: aDiffBuilder newRopedText.
	aDiffBuilder newStyler ifNotNil: [ :aStyler | self styler: aStyler ].
	self updateOutlines
]

{ #category : #'event handling' }
GtDiffElement >> drawMeAndChildrenOnSpartaCanvas: aCanvas [
	| stroke fill |
	super drawMeAndChildrenOnSpartaCanvas: aCanvas.
	stroke := aCanvas stroke
		alpha: 0.2;
		paint: Color black;
		width: 1.
	fill := aCanvas fill
		alpha: 0.2;
		paint: Color yellow.
	outlines
		do: [ :each | 
			fill
				path: (each pathOnSpartaCanvas: aCanvas of: self);
				draw.
			stroke
				path: (each pathOnSpartaCanvas: aCanvas of: self);
				draw ]
]

{ #category : #initialize }
GtDiffElement >> editorLook [
	^ BrGlamorousCodeEditorAptitude
]

{ #category : #initialize }
GtDiffElement >> initialize [
	super initialize.

	self layout: BlLinearLayout horizontal.
	self matchParent.

	self beNormalSize.

	outlines := #().

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
		addChildren: {leftElement.
				separatorElement.
				rightElement}
]

{ #category : #'event handling' }
GtDiffElement >> leftBottomFor: anInteger [
	| range element |
	range := self leftRange.
	anInteger < range first ifTrue: [ ^ 0 ].
	anInteger > range last ifTrue: [ ^ self height ].
	element := leftElement children at: anInteger - range first + 1.
	^ element bounds bottom + leftElement bounds top max: 0
]

{ #category : #'event handling' }
GtDiffElement >> leftCursorChanged [
	| newPosition |
	newPosition := syncScrollRanges
			rightLineFor: (self leftLineForCursor ifNil: [ self leftRange first ]).
	(self rightRange includes: newPosition)
		ifFalse: [ rightElement scrollToPosition: newPosition ]
]

{ #category : #accessing }
GtDiffElement >> leftEditorLook: aLook [
	leftElement aptitude: aLook
]

{ #category : #'event handling' }
GtDiffElement >> leftLineForCursor [
	leftElement editor cursors
		do: [ :each | ^ leftElement text asString lineNumberCorrespondingToIndex: each position ].
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
	| range element |
	range := self leftRange.
	anInteger < range first ifTrue: [ ^ 0 ].
	anInteger > range last ifTrue: [ ^ self height ].
	element := leftElement children at: anInteger - range first + 1.
	^ element bounds top + leftElement bounds top max: 0
]

{ #category : #initialize }
GtDiffElement >> newSeparatorElement [
	^ BlElement new
		constraintsDo: [ :c |
			c vertical matchParent.
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

	outlines := #().
	self updateOutlines
]

{ #category : #'geometry hooks' }
GtDiffElement >> onLayout: aBounds context: aBlElementBoundsUpdateContext [
	super onLayout: aBounds context: aBlElementBoundsUpdateContext.
	
	outlines := #().
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
	| aCanvas stroke fill |
	super paintMeAndChildrenOn: aCompositorPainter offset: anOffset.
	
	aCanvas := aCompositorPainter canvas.
	
	aCanvas transform
		by: [ :t | t translateBy: anOffset ]
		during: [
			stroke := aCanvas stroke
				alpha: 0.2;
				paint: Color black;
				width: 1.
			fill := aCanvas fill
				alpha: 0.2;
				paint: Color yellow.
			outlines
				do: [ :each | 
					fill
						path: (each pathOnSpartaCanvas: aCanvas of: self);
						draw.
					stroke
						path: (each pathOnSpartaCanvas: aCanvas of: self);
						draw ] ]
]

{ #category : #'event handling' }
GtDiffElement >> rightBottomFor: anInteger [
	| range element |
	range := self rightRange.
	anInteger < range first ifTrue: [ ^ 0 ].
	anInteger > range last ifTrue: [ ^ self height ].
	element := rightElement children at: anInteger - range first + 1.
	^ element bounds bottom + rightElement bounds top max: 0
]

{ #category : #'event handling' }
GtDiffElement >> rightCursorChanged [
	| newPosition |
	newPosition := syncScrollRanges
			leftLineFor: (self rightLineForCursor ifNil: [ self rightRange first ]).
	(self leftRange includes: newPosition)
		ifFalse: [ leftElement scrollToPosition: newPosition ]
]

{ #category : #accessing }
GtDiffElement >> rightEditorLook: aLook [
	rightElement aptitude: aLook
]

{ #category : #'event handling' }
GtDiffElement >> rightLineForCursor [
	rightElement editor cursors
		do: [ :each | ^ rightElement text asString lineNumberCorrespondingToIndex: each position ].
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
	| range element |
	range := self rightRange.
	anInteger < range first ifTrue: [ ^ 0 ].
	anInteger > range last ifTrue: [ ^ self height ].
	element := rightElement children at: anInteger - range first + 1.
	^ element bounds top + rightElement bounds top max: 0
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
	outlines := OrderedCollection new.
	ranges := syncScrollRanges
		rangesForLeft: self leftRange
		andRight: self rightRange.
	ranges
		do: [ :each | 
			each isDifference
				ifTrue: [ outlines add: (self outlineFor: each) ] ].
	self invalidate
]
