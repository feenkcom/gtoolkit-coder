Extension { #name : #GtTextualCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addCopyCutPasteContextMenuAddOnsAst: anAst to: coderAddOns [
	<gtCoderContextMenuAddOns: 10>
	coderAddOns
		addContextMenuItem: 'Cut'
			action: [ :aCoderViewModel :anEditorElement | anEditorElement editor cutSelected ]
			id: GtTextualCoderCutContextMenuItemId
			shortcutKey: BrEditorShortcut cut combinationForPlatform userPrintString;
		addContextMenuItem: 'Copy'
			action: [ :aCoderViewModel :anEditorElement | anEditorElement editor copySelected ]
			id: GtTextualCoderCopyContextMenuItemId
			shortcutKey: BrEditorShortcut copy combinationForPlatform userPrintString;
		addContextMenuItem: 'Paste'
			action: [ :aCoderViewModel :anEditorElement | anEditorElement editor paste ]
			id: GtTextualCoderPasteContextMenuItemId
			shortcutKey: BrEditorShortcut paste combinationForPlatform userPrintString
]
