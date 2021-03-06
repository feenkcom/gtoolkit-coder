Class {
	#name : #GtCategoryToggleAptitude,
	#superclass : #GtCoderToggleAptitude,
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #accessing }
GtCategoryToggleAptitude >> initialize [
	super initialize.
	self
		addChangeProperty: #(widget layout)
		with: [ BlLinearLayout horizontal alignCenter ].
	self
		addChangeProperty: #(widget constraints horizontal resizer)
		with: BlLayoutResizer fitContent.
	self
		addChangeProperty: #(widget constraints vertical resizer)
		with: [ BlLayoutResizer exact: 16 ].
	self addChangeProperty: #(widget padding) with: [ BlInsets all: 6 ]
]
