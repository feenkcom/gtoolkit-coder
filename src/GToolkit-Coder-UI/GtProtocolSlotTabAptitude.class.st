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
	self add: BrLayoutResizerAptitude inherit.
	self add: BrLayoutAlignmentAptitude forHorizontalLinearLayout.
	bar := BlElement new
		visibility: BlVisibility hidden;
		background: self theme default primaryBorderColor;
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored vertical alignBottom.
			c vertical exact: 2.
			c horizontal matchParent ].
	self
		add:
			(BrStyleCommonAptitude new
				default: [ :aStyle | 
					aStyle
						padding:
							(BlInsets
								top: 0
								left: 12
								bottom: 0
								right: 12) ]).
	self
		add:
			(BrStyleCommonAptitude new
				@ bar;
				deselected: [ :aStyle | aStyle hidden ];
				selected: [ :aStyle | aStyle visible ]).
	self addChangeAddChildAs: #(content bar) with: [ bar ]
]
