Extension { #name : #GtPharoMethodContextCoder }

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoMethodContextCoder >> asCoderUIModel [
	^ (GtPharoMethodContextCoderViewModel new coder: self)
		selfObject: self context receiver
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoMethodContextCoder >> initializeShortcuts: addOns [
	super initializeShortcuts: addOns.
	
	addOns addShortcut: GtSourceCoderPrintItShortcut new
]
