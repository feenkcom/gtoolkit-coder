Class {
	#name : #GtSourceCoderExpandedWithHeaderLook,
	#superclass : #BrLook,
	#category : #'GToolkit-Coder-UI-Coder - Source Look'
}

{ #category : #initialization }
GtSourceCoderExpandedWithHeaderLook >> initialize [
	super initialize.

	self addAll: {
		GtMethodCoderHeaderLook new.
		GtSourceCoderEditorLook new.
		BrLayoutResizerLook inherit
	}
]
