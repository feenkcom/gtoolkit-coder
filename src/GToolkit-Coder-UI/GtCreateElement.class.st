Class {
	#name : #GtCreateElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'definition'
	],
	#category : #'GToolkit-Coder-UI-Behaviour'
}

{ #category : #'private - instance creation' }
GtCreateElement >> buildSectionLabel: aSectionName [
	
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new glamorousRegularFontAndSize foreground: Color gray; fontSize: 12);
		text: aSectionName, ':';
		focusability: BlFocusability none;
		margin: (BlInsets top: 5 right: 2);
		constraintsDo: [ :c | c grid horizontal alignLeft ]
]

{ #category : #'private - ui' }
GtCreateElement >> buttonMargin [
	^ BlInsets top: 3 left: 0 bottom: 3 right: 5
]

{ #category : #'private - ui' }
GtCreateElement >> editableLabelLook [
	^ BrGlamorousEditableLabelAptitude new
		glamorousCodeFont;
		defaultForeground: Color black;
		fontSize: 10
]

{ #category : #initialization }
GtCreateElement >> initialize [
	super initialize.
	self layout: BlFlowLayout vertical.
	self margin: (BlInsets all: 5).
	self
		constraintsDo: [ :c | 
			c horizontal exact: 400.
			c vertical fitContent ]
]
