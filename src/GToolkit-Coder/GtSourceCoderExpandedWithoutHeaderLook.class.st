Class {
	#name : #GtSourceCoderExpandedWithoutHeaderLook,
	#superclass : #BrLook,
	#category : #'GToolkit-Coder-UI - Source Coder Look'
}

{ #category : #initialization }
GtSourceCoderExpandedWithoutHeaderLook >> initialize [
	super initialize.

	self addAll: {
		GtSourceCoderEditorLook new.
		BrLayoutResizerLook inherit
	}
]
