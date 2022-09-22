Class {
	#name : #GtDiffElementWithLabelStencil,
	#superclass : #BrStencil,
	#instVars : [
		'fromLabelText',
		'toLabelText',
		'diffBuilder',
		'shouldHideDiff'
	],
	#category : #'GToolkit-Coder-UI-Diff'
}

{ #category : #'api - instantiation' }
GtDiffElementWithLabelStencil >> create [
	| headerElement diffContainer |
	
	headerElement := BrHorizontalPane new
		padding: (BlInsets all: 0);
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
		vFitContent.

	self shouldHideDiff ifFalse: [
		diffContainer addChild: self createPanesDiffElement ].
	
	^ diffContainer
]

{ #category : #'building - widgets' }
GtDiffElementWithLabelStencil >> createFromLabel [
	^ BrLabel new 
		aptitude: BrGlamorousLabelAptitude;
		text: (self fromLabelText asRopedText glamorousCodeSmallSize
			foreground: BrGlamorousColors defaultButtonTextColor);
	 	hMatchParent
]

{ #category : #'building - widgets' }
GtDiffElementWithLabelStencil >> createPanesDiffElement [
	| diffWrapper |
	
	diffWrapper := BrVerticalPane new.
	diffWrapper margin: (BlInsets all: 3).
	diffWrapper hMatchParent.
	diffWrapper vFitContent.
	
	diffWrapper 
		addChild: ((GtEpiceaDiffElement on: self diffBuilder) 
			aptitude: GtDiffFlatAptitude;
			vFitContent;
			beSmallSize).

	diffWrapper addAptitude: (BrShadowAptitude new width: 1).
	
	^ diffWrapper
]

{ #category : #'building - widgets' }
GtDiffElementWithLabelStencil >> createToLabel [
	^ BrLabel new 
		aptitude: BrGlamorousLabelAptitude;
		text: (self toLabelText asRopedText glamorousCodeSmallSize
				foreground: BrGlamorousColors defaultButtonTextColor);
	 	hMatchParent 
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> diffBuilder [
	^ diffBuilder
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> diffBuilder: anObject [

	diffBuilder := anObject
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

{ #category : #testing }
GtDiffElementWithLabelStencil >> shouldHideDiff [
	^ shouldHideDiff ifNil: [ false ]
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> shouldHideDiff: anObject [

	shouldHideDiff := anObject
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> toLabelText [
	^ toLabelText
]

{ #category : #accessing }
GtDiffElementWithLabelStencil >> toLabelText: aString [

	toLabelText := aString
]
