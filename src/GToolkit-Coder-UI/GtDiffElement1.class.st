Class {
	#name : #GtDiffElement1,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TBrSizeAdjustable',
	#classTraits : 'TBrLayoutResizable classTrait + TBrSizeAdjustable classTrait',
	#instVars : [
		'leftElement',
		'rightElement',
		'syncScrollRanges',
		'outlines',
		'separatorElement',
		'compositeChange',
		'styler'
	],
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #examples }
GtDiffElement1 class >> example [
	<gtExample>

	^ self on: self exampleDiff
]

{ #category : #examples }
GtDiffElement1 class >> exampleDiff [
	<gtExample>
	^ GtDiffBuilder
		computeDifferencesFrom: self originalString
		to: self newString
		using: GtCharacterGroupDiffSplitter words ignoreWhitespace
]

{ #category : #examples }
GtDiffElement1 class >> exampleFlat [
	<gtExample>

	^ (self on: self exampleDiff) aptitude: GtDiffFlatAptitude
]

{ #category : #examples }
GtDiffElement1 class >> exampleShadow [
	<gtExample>

	^ (self on: self exampleDiff) aptitude: GtDiffShadowAptitude
]

{ #category : #examples }
GtDiffElement1 class >> newString [
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
GtDiffElement1 class >> on: aCompositeDiffChange [
	^ self new
		change: aCompositeDiffChange;
		yourself
]

{ #category : #examples }
GtDiffElement1 class >> originalString [
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
GtDiffElement1 >> buildInterface [
	syncScrollRanges := GtSyncScrollRanges1 createFromChanges: compositeChange.

	self updateOutlines
]

{ #category : #initialize }
GtDiffElement1 >> change: aCompositeDiffChange [
	compositeChange := aCompositeDiffChange.
	leftElement text: self previousRopedText.
	rightElement text: self newRopedText.
	self buildInterface
]

{ #category : #'event handling' }
GtDiffElement1 >> drawMeAndChildrenOnSpartaCanvas: aCanvas [
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
GtDiffElement1 >> editorLook [
	^ BrGlamorousCodeEditorAptitude
]

{ #category : #initialize }
GtDiffElement1 >> initialize [
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
GtDiffElement1 >> leftBottomFor: anInteger [
	| range element |
	range := self leftRange.
	anInteger < range first ifTrue: [ ^ 0 ].
	anInteger > range last ifTrue: [ ^ self height ].
	element := leftElement children at: anInteger - range first + 1.
	^ element bounds bottom + leftElement bounds top max: 0
]

{ #category : #accessing }
GtDiffElement1 >> leftEditorLook: aLook [
	leftElement aptitude: aLook
]

{ #category : #private }
GtDiffElement1 >> leftRange [
	| first |
	first := ((leftElement instVarNamed: 'layoutPositionsRange')
			ifNil: [ 1 ]
			ifNotNil: [ :interval | interval first ]) max: 1.
	^ first to: first + leftElement children size - 1
]

{ #category : #'event handling' }
GtDiffElement1 >> leftScrolled [
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
GtDiffElement1 >> leftStyler: aStyler [
	leftElement editor styler: aStyler
]

{ #category : #'event handling' }
GtDiffElement1 >> leftTopFor: anInteger [
	| range element |
	range := self leftRange.
	anInteger < range first ifTrue: [ ^ 0 ].
	anInteger > range last ifTrue: [ ^ self height ].
	element := leftElement children at: anInteger - range first + 1.
	^ element bounds top + leftElement bounds top max: 0
]

{ #category : #private }
GtDiffElement1 >> newRopedText [
	| text |
	text := compositeChange to asRopedText glamorousCodeFont.
	compositeChange applyAttributesToOutput: text.
	^ text
]

{ #category : #initialize }
GtDiffElement1 >> newSeparatorElement [
	^ BlElement new
		constraintsDo: [ :c |
			c vertical matchParent.
			c horizontal exact: 0 ]
		yourself
]

{ #category : #initialize }
GtDiffElement1 >> newTextElement [
	^ BrEditor new
		focusability: BlFocusability none;
		beReadOnlyWithSelection;
		matchParent;
		aptitude: self editorLook
]

{ #category : #'geometry hooks' }
GtDiffElement1 >> onExtentChanged [ 
	super onExtentChanged.

	outlines := #().
	self updateOutlines
]

{ #category : #'geometry hooks' }
GtDiffElement1 >> onLayout: aBounds context: aBlElementBoundsUpdateContext [
	super onLayout: aBounds context: aBlElementBoundsUpdateContext.
	
	outlines := #().
	self updateOutlines
]

{ #category : #'event handling' }
GtDiffElement1 >> outlineFor: aSyncScrollRange [
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
GtDiffElement1 >> paintMeAndChildrenOn: aCompositorPainter offset: anOffset [
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

{ #category : #private }
GtDiffElement1 >> previousRopedText [
	| text |
	text := compositeChange from asRopedText glamorousCodeFont.
	compositeChange applyAttributesToInput: text.
	^ text
]

{ #category : #'event handling' }
GtDiffElement1 >> rightBottomFor: anInteger [
	| range element |
	range := self rightRange.
	anInteger < range first ifTrue: [ ^ 0 ].
	anInteger > range last ifTrue: [ ^ self height ].
	element := rightElement children at: anInteger - range first + 1.
	^ element bounds bottom + rightElement bounds top max: 0
]

{ #category : #accessing }
GtDiffElement1 >> rightEditorLook: aLook [
	rightElement aptitude: aLook
]

{ #category : #private }
GtDiffElement1 >> rightRange [
	| first |
	first := ((rightElement instVarNamed: 'layoutPositionsRange')
			ifNil: [ 1 ]
			ifNotNil: [ :interval | interval first ]) max: 1.
	^ first to: first + rightElement children size - 1
]

{ #category : #'event handling' }
GtDiffElement1 >> rightScrolled [
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
GtDiffElement1 >> rightStyler: aStyler [
	rightElement editor styler: aStyler
]

{ #category : #'event handling' }
GtDiffElement1 >> rightTopFor: anInteger [
	| range element |
	range := self rightRange.
	anInteger < range first ifTrue: [ ^ 0 ].
	anInteger > range last ifTrue: [ ^ self height ].
	element := rightElement children at: anInteger - range first + 1.
	^ element bounds top + rightElement bounds top max: 0
]

{ #category : #accessing }
GtDiffElement1 >> styler [
	^ styler
]

{ #category : #accessing }
GtDiffElement1 >> styler: anObject [
	styler := anObject.
	styler
		ifNotNil: [ leftElement styler: styler.
			rightElement styler: styler ]
]

{ #category : #'event handling' }
GtDiffElement1 >> updateOutlines [
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
