Extension { #name : #GtCoderKeymapRegistry }

{ #category : #'*GToolkit-Coder-AddOns' }
GtCoderKeymapRegistry >> initializeInlineRenameShortcutCombination [
	<gtKeymapRegistration>
	self 
		initializeShortcut: GtCoderShortcutIds default inlineRenameShortcutId
		with: BlKeyCombination primaryR
]
