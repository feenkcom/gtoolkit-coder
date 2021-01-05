Class {
	#name : #GtClassBreadcrumbToggleLook,
	#superclass : #BrLook,
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #accessing }
GtClassBreadcrumbToggleLook >> initialize [
	super initialize.
	self
		addChangeProperty: #(widget layout)
		with: [ BlLinearLayout horizontal alignCenter ].
	self
		addChangeProperty: #(widget constraints horizontal resizer)
		with: BlLayoutResizer fitContent.

	self add: (BrGlamorousLabelLook new
		foreground: Color black;
		yourself).			
							
	self add: (BrToggleLook new
		// #label;
		activated: [ :aStyle | aStyle foreground: Color black ];
		deactivated: [ :aStyle | aStyle foreground: Color gray ])
]
