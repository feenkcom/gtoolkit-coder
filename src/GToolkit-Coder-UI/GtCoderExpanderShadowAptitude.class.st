Class {
	#name : #GtCoderExpanderShadowAptitude,
	#superclass : #BrLazyStyleCommonAptitude,
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #initialization }
GtCoderExpanderShadowAptitude >> initialize [
	super initialize.

	self
		when: (self state focused)
			style: [ :aStyle | aStyle effect: BrGlamorousFocusedShadowEffect new ];
		when: (self state hovered or: (self state expanded & self state unfocused))
			style: [ :aStyle | aStyle effect: BrGlamorousShadowEffect new ]
]
