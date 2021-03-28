Class {
	#name : #GtClassBreadcrumbToggleAptitude,
	#superclass : #BrAptitude,
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #accessing }
GtClassBreadcrumbToggleAptitude >> initialize [
	super initialize.
	self
		addChangeProperty: #(widget layout)
		with: [ BlLinearLayout horizontal alignCenter ].
	self
		addChangeProperty: #(widget constraints horizontal resizer)
		with: BlLayoutResizer fitContent.

	self add: (BrGlamorousLabelAptitude new
		foreground: Color black;
		yourself).			
							
	self add: (BrToggleAptitude new
		// #label;
		activated: [ :aStyle | aStyle foreground: Color black ];
		deactivated: [ :aStyle | aStyle foreground: Color gray ])
]
