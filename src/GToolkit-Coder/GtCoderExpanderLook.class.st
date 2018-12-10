Class {
	#name : #GtCoderExpanderLook,
	#superclass : #BrGlamorousExpanderLook,
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #initialization }
GtCoderExpanderLook >> initialize [
	super initialize.
	self
		add:
			(BrInteractiveLook new
				style: [ :aStyler | 
					aStyler default: [ sidebar background: Color veryVeryLightGray ].
					aStyler focused: [ sidebar background: (BrGlamorousColors primaryBorderColor alpha: 0.4) ] ]).
	toggle
		background: Color transparent;
		constraintsDo: [ :c | c vertical matchParent ].
	toggle children first constraintsDo: [ :c | c linear vertical alignTop ]
]
