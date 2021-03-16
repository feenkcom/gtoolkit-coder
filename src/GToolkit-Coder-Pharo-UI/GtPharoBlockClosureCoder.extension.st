Extension { #name : #GtPharoBlockClosureCoder }

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoBlockClosureCoder >> asCoderUIModel [
	^ GtSourceCoderViewModel new coder: self
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoBlockClosureCoder >> initializeShortcuts: addOns [
	super initializeShortcuts: addOns.
	
	addOns addShortcut: GtSourceCoderFormatShortcut new
]
