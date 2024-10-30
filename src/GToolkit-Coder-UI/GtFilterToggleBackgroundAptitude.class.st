Class {
	#name : #GtFilterToggleBackgroundAptitude,
	#superclass : #BrToggleAptitude,
	#category : #'GToolkit-Coder-UI-Filters - Support'
}

{ #category : #initialization }
GtFilterToggleBackgroundAptitude >> initialize [
	super initialize.
	self
		activated: [ :aStyle | 
			aStyle background: self theme button defaultBorderColor lighter.
			aStyle
				border: (BlBorder paint: self theme button defaultBackgroundColor width: 1) ]
]