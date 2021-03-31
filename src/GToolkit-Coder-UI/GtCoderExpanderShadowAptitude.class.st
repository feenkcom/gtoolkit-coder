Class {
	#name : #GtCoderExpanderShadowAptitude,
	#superclass : #BrStyleCommonAptitude,
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #initialization }
GtCoderExpanderShadowAptitude >> initialize [
	super initialize.

	self
		when: (self state expanded & self state focused)
			style: [ :aStyle | aStyle effect: BrGlamorousFocusedShadowEffect new ];
		when: (self state expanded & self state unfocused)
			style: [ :aStyle | aStyle effect: BrGlamorousShadowEffect new ]
]
