Class {
	#name : #GtDiffElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TBrSizeAdjustable',
	#classTraits : 'TBrLayoutResizable classTrait + TBrSizeAdjustable classTrait',
	#instVars : [
		'leftElement',
		'rightElement',
		'syncScrollRanges',
		'diff',
		'outlines',
		'separatorElement'
	],
	#category : #'GToolkit-Coder-UI-Diff'
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
GtDiffElement class >> exampleFlat [
	<gtExample>

	^ (self on: self exampleDiff) aptitude: GtDiffFlatAptitude
]

{ #category : #examples }
GtDiffElement class >> exampleShadow [
	<gtExample>

	^ (self on: self exampleDiff) aptitude: GtDiffShadowAptitude
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
	syncScrollRanges := GtSyncScrollRanges createFromDiff: diff.

	leftElement text: self previousRopedText.
	diff newStyler ifNotNil: [ :aStyler | leftElement styler: aStyler ].

	rightElement text: self newRopedText.
	diff newStyler ifNotNil: [ :aStyler | rightElement styler: aStyler ].

	self updateOutlines
]

{ #category : #initialize }
GtDiffElement >> diff: aDiffBuilder [
	diff := aDiffBuilder.
	self buildInterface
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

	rightElement := self newTextElement
		id: GtDiffNewTextId;
		when: BlElementScrolledEvent do: [ :e | self rightScrolled ].
	
	separatorElement := self newSeparatorElement
		id: GtDiffSeparatorId.
	
	self addChildren: { 
		leftElement.
		separatorElement.
		rightElement
	}.
]

{ #category : #'event handling' }
GtDiffElement >> leftBottomFor: anInteger [
	| range element |
	range := self leftRange.
	anInteger < range first
		ifTrue: [ ^ 0 ].
	anInteger > range last
		ifTrue: [ ^ self height ].
	element := (leftElement children at: anInteger - range first + 1).
	^ (element bounds bottom + leftElement padding top)
		max: 0
]

{ #category : #accessing }
GtDiffElement >> leftEditorLook: aLook [
	leftElement aptitude: aLook
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
			"rightElement scrollBy: 0@offset" ]
		ifFalse: [ "rightElement scrollToPosition: newPosition" ].

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
	anInteger < range first
		ifTrue: [ ^ 0 ].
	anInteger > range last
		ifTrue: [ ^ self height ].
	element := (leftElement children at: anInteger - range first + 1).
	^ (element bounds top + leftElement padding top)
		max: 0
]

{ #category : #private }
GtDiffElement >> newRopedText [
	^ diff newRopedText
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
		focusability: BlFocusability none;
		beReadOnlyWithSelection;
		matchParent;
		aptitude: self editorLook
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
	^ diff previousRopedText
]

{ #category : #'event handling' }
GtDiffElement >> rightBottomFor: anInteger [
	| range element |
	range := self rightRange.
	anInteger < range first
		ifTrue: [ ^ 0 ].
	anInteger > range last
		ifTrue: [ ^ self height ].
	element := (rightElement children at: anInteger - range first + 1).
	^ (element bounds bottom + rightElement padding top)
		max: 0
]

{ #category : #accessing }
GtDiffElement >> rightEditorLook: aLook [
	rightElement aptitude: aLook
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
			"leftElement scrollBy: 0@ offset" ]
		ifFalse: [ "leftElement scrollToPosition: newPosition" ].

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
	anInteger < range first
		ifTrue: [ ^ 0 ].
	anInteger > range last
		ifTrue: [ ^ self height ].
	element := (rightElement children at: anInteger - range first + 1).
	^ (element bounds top + rightElement padding top)
		max: 0
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
