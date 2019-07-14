Class {
	#name : #GtClassBreadcrumbToggleLook,
	#superclass : #BrToggleLook,
	#instVars : [
		'label'
	],
	#category : #'GToolkit-Coder-Looks'
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
	self
		add:
			(label := BrGlamorousLabelLook new
				foreground: Color black;
				yourself).
	self
		addChange:
			(BrLookChange new
				up: [ :e | 
					self flag: 'Working around a toggled display issue'.
					self widget isActivated
						ifTrue: [ self toggleActivated ]
						ifFalse: [ self toggleDeactivated ] ];
				down: [ :e |  ];
				yourself)
]

{ #category : #'event handling' }
GtClassBreadcrumbToggleLook >> toggleActivated [
	super toggleActivated.
	label foreground: Color black
]

{ #category : #'event handling' }
GtClassBreadcrumbToggleLook >> toggleDeactivated [
	super toggleDeactivated.
	label foreground: Color gray
]
