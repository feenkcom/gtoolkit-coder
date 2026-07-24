Extension { #name : #BlDynamicShortcut }

{ #category : #'*GToolkit-Coder-UI' }
BlDynamicShortcut >> coderShortcutId: anId [
	self 
		shortcutId: anId 
		inRegistry: BlShortcutKeymapRegistry default coder
]
