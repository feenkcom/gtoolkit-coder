Class {
	#name : #GtFilterToggleGroupAptitude,
	#superclass : #BrToggleGroupAptitude,
	#category : 'GToolkit-Coder-UI-Filters - Support'
}

{ #category : #initialization }
GtFilterToggleGroupAptitude >> initialize [
	super initialize.
	self
		addChangeProperty: #(widget layout)
		with: [ BlLinearLayout horizontal cellSpacing: 0 ].
	self
		addChangeProperty: #(widget geometry)
		with: [ BlRoundedRectangleGeometry cornerRadius: 3 ].
	self
		addChangeProperty: #(widget background)
		with:
			[ self theme default contentBackground ].
]
