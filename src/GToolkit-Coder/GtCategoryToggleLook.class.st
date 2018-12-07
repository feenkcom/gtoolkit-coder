Class {
	#name : #GtCategoryToggleLook,
	#superclass : #GtCoderToggleLook,
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtCategoryToggleLook >> initializeLook [
	super initializeLook.
	
	widget layout: BlLinearLayout horizontal alignCenter.
	widget constraintsDo: [ :c |
		c horizontal fitContent.
		c vertical exact: 16.
		c padding: (BlInsets all: 6) ]
]
