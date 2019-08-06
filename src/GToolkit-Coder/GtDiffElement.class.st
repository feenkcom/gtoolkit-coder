Class {
	#name : #GtDiffElement,
	#superclass : #BlElement,
	#instVars : [
		'leftElement',
		'rightElement',
		'syncScrollRanges',
		'diff',
		'outlines',
		'updateDelay'
	],
	#category : #'GToolkit-Coder-Diff'
}

{ #category : #examples }
GtDiffElement class >> example [
	<gtExample>
	^ self on: self exampleDiff
]

{ #category : #examples }
GtDiffElement class >> exampleDiff [
	<gtExample>
	^ TextDiffBuilder from: self originalString to: self newString
]

{ #category : #examples }
GtDiffElement class >> newString [
	<gtExample>
	^ String
		streamContents: [ :str | 
			1 to: 1000 by: 6 do: [ :i | 
				str
					print: i;
					cr;
					print: i + 1;
					cr;
					print: i + 2;
					cr ] ]
]

{ #category : #'instance creation' }
GtDiffElement class >> on: aDiffBuilder [
	^ self new
		diff: aDiffBuilder;
		yourself
]

{ #category : #examples }
GtDiffElement class >> originalString [
	<gtExample>
	^ String
		streamContents: [ :str | 
			1 to: 1000 by: 5 do: [ :i | 
				str
					print: i;
					cr;
					print: i + 1;
					cr;
					print: i + 2;
					cr ] ]
]

{ #category : #private }
GtDiffElement >> buildInterface [
	| left right |
	syncScrollRanges := GtSyncScrollRanges createFromDiff: diff.
	self
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	left := BrTextEditor new.
	left text: self previousRopedText.
	diff newStyler ifNotNil: [ :style | left styler: style ].
	self
		addChild:
			(leftElement := BrEditor new
				padding: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal fitContent.
					c vertical fitContent ];
				look: BrGlamorousCodeEditorLook new;
				when: BlInfiniteScrollChangedEvent do: [ :e | self leftScrolled ];
				editor: left).
	self
		addChild:
			(BlElement new
				width: 75;
				yourself).
	right := BrTextEditor new.
	right text: self newRopedText.
	diff newStyler ifNotNil: [ :style | right styler: style ].
	self
		addChild:
			(rightElement := BrEditor new
				padding: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal fitContent.
					c vertical fitContent ];
				look: BrGlamorousCodeEditorLook new;
				when: BlInfiniteScrollChangedEvent
					do: [ :e | self rightScrolled ];
				editor: right).
	self updateOutlines
]

{ #category : #'initialize-release' }
GtDiffElement >> diff: aDiffBuilder [
	diff := aDiffBuilder.
	self buildInterface
]

{ #category : #'event handling' }
GtDiffElement >> drawMeAndChildrenOnSpartaCanvas: aCanvas [
	| stroke fill |
	super drawMeAndChildrenOnSpartaCanvas: aCanvas.
	stroke := aCanvas stroke
		alpha: 1.0;
		paint: Color black;
		width: 1.
	fill := aCanvas fill
		alpha: 0.1;
		paint: Color yellow.
	outlines
		do: [ :each | 
			fill
				path: (each pathOnSpartaCanvas: aCanvas);
				draw.
			stroke
				path: (each pathOnSpartaCanvas: aCanvas);
				draw ]
]

{ #category : #'initialize-release' }
GtDiffElement >> initialize [
	super initialize.
	outlines := #().
	updateDelay := BlDelayedTaskAction new.
	updateDelay delay: 5 milliSeconds.
	updateDelay element: self
]

{ #category : #'event handling' }
GtDiffElement >> leftBottomFor: anInteger [
	| range |
	range := self leftRange.
	anInteger < range first
		ifTrue: [ ^ 0 ].
	anInteger > range last
		ifTrue: [ ^ self height ].
	^ (leftElement children at: anInteger - range first + 1) bounds bottom
		max: 0
]

{ #category : #private }
GtDiffElement >> leftRange [
	| first |
	first := (leftElement instVarNamed: 'layoutPositionsRange')
		ifNil: [ 1 ]
		ifNotNil: [ :interval | interval first ].
	^ first to: first + leftElement children size - 1
]

{ #category : #'event handling' }
GtDiffElement >> leftScrolled [
	| newPosition |
	newPosition := syncScrollRanges rightLineFor: self leftRange first.
	(self rightRange includes: newPosition)
		ifTrue: [ | offset |
			offset := rightElement children first bounds position y.
			1 to: newPosition - self rightRange first do: [ :i | offset := offset + (rightElement children at: i) height ].
			rightElement scrollVerticallyBy: offset ]
		ifFalse: [ rightElement scrollToPosition: newPosition ].
	self updateOutlines
]

{ #category : #'event handling' }
GtDiffElement >> leftTopFor: anInteger [
	| range |
	range := self leftRange.
	anInteger < range first
		ifTrue: [ ^ 0 ].
	anInteger > range last
		ifTrue: [ ^ self height ].
	^ (leftElement children at: anInteger - range first + 1) bounds top
		max: 0
]

{ #category : #private }
GtDiffElement >> newRopedText [
	| text |
	text := '' asRopedText.
	diff
		patchSequenceDoIfMatch: [ :string | 
			text
				append: string asRopedText;
				append: String cr asRopedText ]
		ifInsert: [ :string | 
			text
				append: string asRopedText;
				append: String cr asRopedText ]
		ifRemove: [ :string |  ].
	^ text
]

{ #category : #'geometry hooks' }
GtDiffElement >> notifyExtentChanged [
	super notifyExtentChanged.
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

{ #category : #private }
GtDiffElement >> previousRopedText [
	| text |
	text := '' asRopedText.
	diff
		patchSequenceDoIfMatch: [ :string | 
			text
				append: string asRopedText;
				append: String cr asRopedText ]
		ifInsert: [ :string |  ]
		ifRemove: [ :string | 
			text
				append: string asRopedText;
				append: String cr asRopedText ].
	^ text
]

{ #category : #'event handling' }
GtDiffElement >> rightBottomFor: anInteger [
	| range |
	range := self rightRange.
	anInteger < range first
		ifTrue: [ ^ 0 ].
	anInteger > range last
		ifTrue: [ ^ self height ].
	^ (rightElement children at: anInteger - range first + 1) bounds bottom
		max: 0
]

{ #category : #private }
GtDiffElement >> rightRange [
	| first |
	first := (rightElement instVarNamed: 'layoutPositionsRange')
		ifNil: [ 1 ]
		ifNotNil: [ :interval | interval first ].
	^ first to: first + rightElement children size - 1
]

{ #category : #'event handling' }
GtDiffElement >> rightScrolled [
	| newPosition |
	newPosition := syncScrollRanges leftLineFor: self rightRange first.
	(self leftRange includes: newPosition)
		ifTrue: [ | offset |
			offset := leftElement children first bounds position y.
			1 to: newPosition - self leftRange first do: [ :i | offset := offset + (leftElement children at: i) height ].
			leftElement scrollVerticallyBy: offset ]
		ifFalse: [ leftElement scrollToPosition: newPosition ].
	self updateOutlines
]

{ #category : #'event handling' }
GtDiffElement >> rightTopFor: anInteger [
	| range |
	range := self rightRange.
	anInteger < range first
		ifTrue: [ ^ 0 ].
	anInteger > range last
		ifTrue: [ ^ self height ].
	^ (rightElement children at: anInteger - range first + 1) bounds top
		max: 0
]

{ #category : #'event handling' }
GtDiffElement >> updateOutlines [
	updateDelay stop.
	updateDelay
		action: [ | ranges |
			outlines := OrderedCollection new.
			ranges := syncScrollRanges
				rangesForLeft: self leftRange
				andRight: self rightRange.
			ranges
				do: [ :each | 
					each isDifference
						ifTrue: [ outlines add: (self outlineFor: each) ] ].
			self invalidate ].
	updateDelay start
]
