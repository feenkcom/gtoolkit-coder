Extension { #name : #GtPharoSnippetCoder }

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSnippetCoder >> asCoderUIModel [
	^ GtSourceCoderViewModel new coder: self
]

{ #category : #'*GToolkit-Coder-Pharo-UI' }
GtPharoSnippetCoder >> initializeShortcuts [
	super initializeShortcuts.

	addOns
		addShortcut: GtSourceCoderDoItShortcut new;
		addShortcut: GtSourceCoderDoItAndInspectShortcut new;
		addShortcut: GtSourceCoderPrintItShortcut new
]
