Class {
	#name : #GtProtocolSlotTabAptitude,
	#superclass : #BrTabAptitude,
	#instVars : [
		'bar'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #accessing }
GtProtocolSlotTabAptitude >> initialize [
	super initialize.
	self add: (BrGlamorousTextLabelAptitude new foreground: Color gray).
	self add: BrGlamorousTabActionbarAptitude new.
	self add: BrLayoutAlignmentAptitude new.
	self
		addChangeProperty: #(widget layout)
		with: [ BlLinearLayout horizontal ].
	bar := BlElement new
		visibility: BlVisibility hidden;
		background: self theme default primaryBorderColor;
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored vertical alignBottom.
			c vertical exact: 1.
			c horizontal matchParent ].
	self
		add:
			(BrStyleCommonAptitude new
				default: [ :aStyle | 
					aStyle
						padding:
							(BlInsets
								top: 2
								left: 12
								bottom: 2
								right: 12) ]).
	self
		add:
			(BrStyleCommonAptitude new
				@ bar;
				deselected: [ :aStyle | aStyle hidden ];
				selected: [ :aStyle | aStyle visible ]).
	self addChangeAddChildAs: #(content bar) with: [ bar ]
]
