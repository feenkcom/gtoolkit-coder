Extension { #name : #GtPharoMethodContextCoder }

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoMethodContextCoder >> asCoderUIModel [
	^ GtPharoMethodContextCoderViewModel new coder: self
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoMethodContextCoder >> initializeShortcuts [ 
	super initializeShortcuts.
	
	addOns addShortcut: GtSourceCoderPrintItShortcut new
]
