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
		addChangeProperty: #(widget constraints vertical resizer)
		with: [ BlLayoutResizer exact: 16 ].
	self addChangeProperty: #(widget padding) with: [ BlInsets all: 6 ].
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
