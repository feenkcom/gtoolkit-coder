Class {
	#name : #GtCoderExpanderShadowLook,
	#superclass : #BrInteractiveCommonLook,
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #initialization }
GtCoderExpanderShadowLook >> initialize [
	| shadowLook focusedShadowLook |
	super initialize.
	
	shadowLook := BrShadowLook new.
	focusedShadowLook := BrShadowLook new color: (BrGlamorousColors primaryBorderColor alpha: 0.4).

	self
		default: [ 			
			self remove: shadowLook.
			self remove: focusedShadowLook ];						
		when: (self state expanded & self state focused)
			style: [ self add: focusedShadowLook ];
		when: (self state expanded & self state unfocused)
			style: [ self add: shadowLook ]
]
