Class {
	#name : #GtCoderExpanderAptitude,
	#superclass : #GtCoderExpanderWithoutShadowAptitude,
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #initialization }
GtCoderExpanderAptitude >> initialize [
	super initialize.
	
	self add: GtCoderExpanderShadowAptitude new
]
