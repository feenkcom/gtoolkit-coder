Extension { #name : #GtTextualCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addCopyCutPasteContextMenuAddOnsAst: anAst to: coderAddOns [
	<gtCoderContextMenuAddOns: 10>
		| mod |
	mod := OSPlatform current defaultModifier name.
	coderAddOns
		addContextMenuItem: 'Cut'
			action: [ :aCoderViewModel :anEditorElement | anEditorElement editor cutSelected ]
			id: GtTextualCoderCutContextMenuItemId
			shortcutKey: mod, '-X';
		addContextMenuItem: 'Copy'
			action: [ :aCoderViewModel :anEditorElement | anEditorElement editor copySelected ]
			id: GtTextualCoderCopyContextMenuItemId
			shortcutKey: mod, '-C';
		addContextMenuItem: 'Paste'
			action: [ :aCoderViewModel :anEditorElement | anEditorElement editor paste ]
			id: GtTextualCoderPasteContextMenuItemId
			shortcutKey: mod, '-V'
]
