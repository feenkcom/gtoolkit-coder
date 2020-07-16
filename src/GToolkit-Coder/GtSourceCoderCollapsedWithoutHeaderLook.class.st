Class {
	#name : #GtSourceCoderCollapsedWithoutHeaderLook,
	#superclass : #BrLook,
	#category : #'GToolkit-Coder-UI - Source Coder Look'
}

{ #category : #initialization }
GtSourceCoderCollapsedWithoutHeaderLook >> initialize [
	super initialize.
	
	self addAll: {
		GtSourceCoderCollapsedTextLook new.
		BrLayoutResizerLook inherit
	}
]
