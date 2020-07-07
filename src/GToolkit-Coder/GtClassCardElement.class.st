Class {
	#name : #GtClassCardElement,
	#superclass : #GtCoderCardElement,
	#instVars : [
		'commentElement'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtClassCardElement >> coder: aCoder [
	super coder: aCoder.
	
	self commentText
		ifEmpty: [ commentElement visibility: BlVisibility gone ]
		ifNotEmpty: [ :aText |
			commentElement
				text: aText;
				visibility: BlVisibility visible ]
]

{ #category : #'building ui' }
GtClassCardElement >> commentText [
	| comment |
	comment := coder theClass organization comment.
	comment size > 100 ifTrue: [ comment := (comment first: 100) , '...' ].
	^ comment asRopedText
]

{ #category : #'building ui' }
GtClassCardElement >> detailsLabel [
	| class |
	class := coder theClass.
	^ 'Super: '
	  , (class superclass ifNil: [ '' ] ifNotNil: [ :spr | spr name ])
]

{ #category : #initialization }
GtClassCardElement >> initialize [
	super initialize.

	commentElement := BrEditor new
		beInSingleCompositionLayer;
		look: (BrGlamorousRegularEditorLook new thin foreground: BrGlamorousColors defaultButtonTextColor);
		text: '';
		beReadOnlyWithoutSelection;
		visibility: BlVisibility gone;
		hMatchParent;
		vFitContent;
		padding: (BlInsets left: 1);
		when: BlClickEvent do: [ :anEvent | 
			anEvent consumed: true.
			self selectCoder ].

	self addChild: commentElement
]
