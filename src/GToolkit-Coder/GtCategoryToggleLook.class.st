Class {
	#name : #GtCategoryToggleLook,
	#superclass : #GtCoderToggleLook,
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #'as yet unclassified' }
GtCategoryToggleLook >> initialize [
	super initialize.
	changes
		add:
			(#(widget layout)
				asBrLookPropertyChangeWithValue: [ BlLinearLayout horizontal alignCenter ])
]

{ #category : #initialization }
GtCategoryToggleLook >> initializeLook [
	super initializeLook.
	self widget
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical exact: 16.
			c padding: (BlInsets all: 6) ]
]
