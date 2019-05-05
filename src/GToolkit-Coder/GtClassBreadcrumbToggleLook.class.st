Class {
	#name : #GtClassBreadcrumbToggleLook,
	#superclass : #GtCoderToggleLook,
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #'as yet unclassified' }
GtClassBreadcrumbToggleLook >> initialize [
	super initialize.
	changes
		add:
			(#(widget layout)
				asBrLookPropertyChangeWithValue: [ BlLinearLayout horizontal alignCenter ])
]

{ #category : #initialization }
GtClassBreadcrumbToggleLook >> initializeLook [
	super initializeLook.
	self widget
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical exact: 16.
			c padding: (BlInsets all: 6) ]
]
