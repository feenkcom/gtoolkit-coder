Class {
	#name : #GtSourceCoderCollapsedWithHeaderLook,
	#superclass : #BrLook,
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
}

{ #category : #initialization }
GtSourceCoderCollapsedWithHeaderLook >> initialize [
	super initialize.

	self addAll: {
		GtMethodCoderHeaderLook new.
		GtSourceCoderCollapsedTextLook new.
		BrLayoutResizerLook inherit
	}
]
