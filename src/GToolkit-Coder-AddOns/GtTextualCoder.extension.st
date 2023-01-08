Extension { #name : #GtTextualCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addContextMenuItemFrom: shortcut withId: menuId to: coderAddOns [
	coderAddOns
		addContextMenuItem: shortcut name
		action: [ :aCoderViewModel :anEditorElement | 
			shortcut
				performOnEditor: anEditorElement editor
				element: anEditorElement
				dueTo: nil ]
		id: menuId
		shortcutKey: shortcut combinationForPlatform gtDisplayString
]

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addCopyCutPasteContextMenuAddOnsAst: anAst to: coderAddOns [
	<gtCoderContextMenuAddOns: 1000>
	self
		addContextMenuItemFrom: BrEditorShortcut cut
			withId: GtTextualCoderCutContextMenuItemId
			to: coderAddOns;
		addContextMenuItemFrom: BrEditorShortcut copy
			withId: GtTextualCoderCopyContextMenuItemId
			to: coderAddOns;
		addContextMenuItemFrom: BrEditorShortcut paste
			withId: GtTextualCoderPasteContextMenuItemId
			to: coderAddOns
]
