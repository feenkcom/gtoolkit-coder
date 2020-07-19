Class {
	#name : #GtSourceCoderCollapsedWithHeaderLook,
	#superclass : #BrLook,
	#category : #'GToolkit-Coder-UI - Source Coder Look'
}

{ #category : #initialization }
GtSourceCoderCollapsedWithHeaderLook >> initialize [
	super initialize.

	self addAll: {
		GtSourceCoderHeaderLook new.
		GtSourceCoderCollapsedTextLook new.
		BrLayoutResizerLook inherit
	}
]
