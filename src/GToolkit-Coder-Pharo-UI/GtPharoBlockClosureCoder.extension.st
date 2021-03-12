Extension { #name : #GtPharoBlockClosureCoder }

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoBlockClosureCoder >> asCoderUIModel [
	^ GtSourceCoderViewModel new coder: self
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoBlockClosureCoder >> initializeShortcuts [
	super initializeShortcuts.
	
	addOns addShortcut: GtSourceCoderFormatShortcut new
]
