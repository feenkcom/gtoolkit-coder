Class {
	#name : #GtCoderExpanderLook,
	#superclass : #GtCoderExpanderWithoutShadowLook,
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #initialization }
GtCoderExpanderLook >> initialize [
	super initialize.
	
	self add: GtCoderExpanderShadowLook new
]
