Class {
	#name : #GtCoderCardElement,
	#superclass : #BlElement,
	#instVars : [
		'coder',
		'coderNameLabel',
		'coderDetailsLabel'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #accessing }
GtCoderCardElement >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderCardElement >> coder: anObject [
	coder := anObject.
	coderNameLabel text: (self coderNameTextFrom: coder coderName).
	self detailsLabel
		ifEmpty: [ coderDetailsLabel visibility: BlVisibility gone ]
		ifNotEmpty: [ :aDetailsString | 
			coderDetailsLabel
				visibility: BlVisibility visible;
				text: (self coderDetailsTextFrom: aDetailsString) ]
]

{ #category : #'private - instance creation' }
GtCoderCardElement >> coderDetailsTextFrom: aString [
	"Convert a coder's details to a styled text"

	<return: #BlText>
	^ aString asRopedText glamorousRegularFont
		foreground: self theme button defaultTextColor
]

{ #category : #'private - instance creation' }
GtCoderCardElement >> coderNameTextFrom: aString [
	"Convert a coder's name to a styled text"
	<return: #BlText>
	
	^ aString asRopedText glamorousCodeFont bold
]

{ #category : #'building ui' }
GtCoderCardElement >> detailsLabel [
	^ ''
]

{ #category : #initialization }
GtCoderCardElement >> initialize [
	super initialize.
	self aptitude: (BrGlamorousButtonExteriorAptitude new borderPaint: Color transparent).
	self layout: (BlLinearLayout vertical cellSpacing: 2).
	self constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical fitContent ].

	self margin: (BlInsets
			 top: 5
			 left: 10
			 bottom: 5
			 right: 10).
	self padding: (BlInsets all: 5).
	self when: BlClickEvent do: [ :event | self selectCoder ].

	coderNameLabel := BlShrinkingTextElement new
		text: (self coderNameTextFrom: 'Coder');
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].

	coderDetailsLabel := BlShrinkingTextElement new
		visibility: BlVisibility gone;
		text: (self coderDetailsTextFrom: '');
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].

	self addChildren: { coderNameLabel . coderDetailsLabel }
]

{ #category : #private }
GtCoderCardElement >> selectCoder [
	| anEvent |

	anEvent := (GtCoderToReplace new coder: coder).
	self fireEvent: anEvent.

	anEvent isConsumed
		ifFalse: [ self phlow spawnObject: anEvent coder ]
]
