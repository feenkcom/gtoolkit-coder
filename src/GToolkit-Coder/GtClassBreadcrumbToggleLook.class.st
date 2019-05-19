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
				asBrLookPropertyChangeWithValue: [ BlLinearLayout horizontal alignCenter ]).
	changes
		add:
			(#(widget constraints horizontal resizer)
				asBrLookPropertyChangeWithValue: BlLayoutResizer fitContent).
	changes
		add:
			(#(widget constraints vertical resizer)
				asBrLookPropertyChangeWithValue: [ BlLayoutResizer exact: 16 ]).
	changes
		add:
			(#(widget padding)
				asBrLookPropertyChangeWithValue: [ BlInsets all: 6 ])
]
