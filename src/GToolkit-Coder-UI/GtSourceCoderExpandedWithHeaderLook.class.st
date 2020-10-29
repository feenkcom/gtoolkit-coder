Class {
	#name : #GtSourceCoderExpandedWithHeaderLook,
	#superclass : #BrLook,
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
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
