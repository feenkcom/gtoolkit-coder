Class {
	#name : #GtSourceCoderCollapsedWithoutHeaderLook,
	#superclass : #BrLook,
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
}

{ #category : #initialization }
GtSourceCoderCollapsedWithoutHeaderLook >> initialize [
	super initialize.
	
	self addAll: {
		GtSourceCoderCollapsedTextAndExampleLook new.
		BrLayoutResizerLook inherit
	}
]
