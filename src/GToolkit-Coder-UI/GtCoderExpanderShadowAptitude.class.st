Class {
	#name : #GtCoderExpanderShadowAptitude,
	#superclass : #BrLazyStyleCommonAptitude,
	#classVars : [
		'IsWithPermanentShadows'
	],
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #settings }
GtCoderExpanderShadowAptitude class >> isWithPermanentShadows [
	^ IsWithPermanentShadows ifNil: [ IsWithPermanentShadows := false ]
]

{ #category : #settings }
GtCoderExpanderShadowAptitude class >> isWithPermanentShadows: aBoolean [
	"Set to true if you want to display shadows around all expanded method coders.
	Set to false if you want to display shadows only around focused and hovered expanded method coders."

	IsWithPermanentShadows := aBoolean
]

{ #category : #initialization }
GtCoderExpanderShadowAptitude >> initialize [
	| aHoverState |
	super initialize.

	aHoverState := self class isWithPermanentShadows  
		ifTrue: [ (self state hovered or: (self state expanded & self state unfocused)) ]
		ifFalse: [ self state hovered and: self state unfocused ].
	
	self
		when: self state focused
			style: [ :aStyle | aStyle effect: BrGlamorousFocusedShadowEffect new ];
		when: aHoverState
			style: [ :aStyle | aStyle effect: BrGlamorousShadowEffect new ]
]
