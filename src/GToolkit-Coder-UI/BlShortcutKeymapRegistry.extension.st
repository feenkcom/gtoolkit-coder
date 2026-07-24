Extension { #name : #BlShortcutKeymapRegistry }

{ #category : #'*GToolkit-Coder-UI' }
BlShortcutKeymapRegistry >> coder [
	<gtKeymapRegistry>
	^ self ensureRegistryCategoryOfType: GtCoderKeymapRegistry
]
