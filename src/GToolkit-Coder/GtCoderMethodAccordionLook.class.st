Class {
	#name : #GtCoderMethodAccordionLook,
	#superclass : #BrAccordionLook,
	#instVars : [
		'contentContainer',
		'bar'
	],
	#category : #'GToolkit-Coder-UI - Looks'
}

{ #category : #initialization }
GtCoderMethodAccordionLook >> initialize [
	super initialize.

	contentContainer := BlElement new.
	contentContainer layout: BlLinearLayout horizontal.
	contentContainer background: Color white.
	contentContainer constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	
	bar := BlElement new.
	bar background: (Color gray alpha: 0.2).
	bar constraintsDo: [ :c |
		c margin: (BlInsets left: 7).
		c horizontal exact: 3.
		c vertical matchParent ].
	contentContainer addChild: bar.
	
	self addAll: {
		BrLayoutLook linearVertical vFitContent hMatchParent.
		BrInteractiveLook new style: [ :aStyler |
			"aStyler default: [ :aWidget | aWidget background: BrGlamorousColors lightBorderColor ].
			aStyler focused: [ :aWidget | aWidget background: BrGlamorousColors primaryBorderColor ]" ].
	}
]

{ #category : #initialization }
GtCoderMethodAccordionLook >> initializeLook [
	super initializeLook.
	
	self widget addChild: contentContainer as: #content
]
