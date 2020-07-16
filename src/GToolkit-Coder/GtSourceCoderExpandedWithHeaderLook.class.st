Class {
	#name : #GtSourceCoderExpandedWithHeaderLook,
	#superclass : #BrLook,
	#category : #'GToolkit-Coder-UI - Source Coder Look'
}

{ #category : #initialization }
GtSourceCoderExpandedWithHeaderLook >> initialize [
	super initialize.

	self addAll: {
		GtSourceCoderHeaderLook new.
		GtSourceCoderEditorLook new.
		BrLayoutResizerLook inherit
	}
]
