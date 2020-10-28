Class {
	#name : #GtCoderOneLineElement,
	#superclass : #BlElement,
	#instVars : [
		'coder',
		'coderNameLabel',
		'coderDetailsLabel'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtCoderOneLineElement >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderOneLineElement >> coder: aCoder [
	coder := aCoder.
	
	coderNameLabel text: (self coderNameTextFrom: coder name).

	self detailsLabel
		ifEmpty: [ coderDetailsLabel visibility: BlVisibility gone ]
		ifNotEmpty: [ :aDetailsString |
			coderDetailsLabel
				visibility: (BlVisibility visible);
				text: (self coderDetailsTextFrom: aDetailsString) ]
]

{ #category : #'private - instance creation' }
GtCoderOneLineElement >> coderDetailsTextFrom: aString [
	"Convert a coder's details to a styled text"
	<return: #BlText>

	^ aString asRopedText
]

{ #category : #'private - instance creation' }
GtCoderOneLineElement >> coderNameTextFrom: aString [
	"Convert a coder's name to a styled text"
	<return: #BlText>
	
	^ aString asRopedText
]

{ #category : #'building ui' }
GtCoderOneLineElement >> detailsLabel [
	^ ''
]

{ #category : #initialization }
GtCoderOneLineElement >> initialize [
	super initialize.
	self viewModel: (BrInteractiveModel new addStates: { 
				 BrEnablementModel new.
				 BrPressModel new.
				 BrHoverModel new }).
	self look: (BrGlamorousButtonExteriorLook new borderPaint: Color transparent).
	self layout: BlLinearLayout horizontal alignCenterLeft.
	self constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical fitContent ].

	self margin: (BlInsets top: 3 left: 5 bottom: 3 right: 5).
	self padding: (BlInsets top: 5 left: 5 bottom: 5 right: 5).
	self when: BlClickEvent do: [ :event | self selectCoder ].

	coderNameLabel := BrLabel new
		look: (BrGlamorousLabelLook new glamorousCodeFont bold);
		text: (self coderNameTextFrom: 'Coder');
		fitContent.

	coderDetailsLabel := BrLabel new
		visibility: BlVisibility gone;
		look: (BrGlamorousLabelLook new glamorousRegularFont foreground: BrGlamorousColors defaultButtonTextColor);
		text: (self coderDetailsTextFrom: '');
		hMatchParent;
		vFitContent.

	coderDetailsLabel margin: (coderDetailsLabel margin + (BlInsets left: 10)).

	self addChildren: { coderNameLabel . coderDetailsLabel }
]

{ #category : #private }
GtCoderOneLineElement >> selectCoder [
	| anEvent |

	anEvent := (GtCoderToReplace new coder: coder).
	self fireEvent: anEvent.

	anEvent isConsumed
		ifFalse: [ self phlow spawnObject: anEvent coder ]
]
