Class {
	#name : #GtCoderExpanderShadowLook,
	#superclass : #BrStyleCommonLook,
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #initialization }
GtCoderExpanderShadowLook >> initialize [
	| shadowLook focusedShadowLook |
	super initialize.
	
	shadowLook := BrShadowLook new.
	
	focusedShadowLook := BrShadowLook new color: (BrGlamorousColors primaryBorderColor alpha: 0.4).

	self
		when: (self state expanded & self state focused)
			style: [ :aStyle |
				aStyle
					do: [ self add: focusedShadowLook ]
					after: [ self remove: focusedShadowLook ] ];
		when: (self state expanded & self state unfocused)
			style: [  :aStyle |
				aStyle
					do: [ self add: shadowLook ]
					after: [ self remove: shadowLook ] ]
]
