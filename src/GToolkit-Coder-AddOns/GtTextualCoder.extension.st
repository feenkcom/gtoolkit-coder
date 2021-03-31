Extension { #name : #GtTextualCoder }

{ #category : #'*GToolkit-Coder-AddOns' }
GtTextualCoder >> addCopyCutPasteContextMenuAddOnsAst: anAst to: coderAddOns [
	<gtCoderContextMenuAddOns: 10>
	coderAddOns
		addContextMenuItem: 'Cut'
			action: [ :aCoderViewModel :aClickEvent :anEditorElement | anEditorElement editor cutSelected ]
			id: GtTextualCoderCutContextMenuItemId;
		addContextMenuItem: 'Copy'
			action: [ :aCoderViewModel :aClickEvent :anEditorElement | anEditorElement editor copySelected ]
			id: GtTextualCoderCopyContextMenuItemId;
		addContextMenuItem: 'Paste'
			action: [ :aCoderViewModel :aClickEvent :anEditorElement | anEditorElement editor paste ]
			id: GtTextualCoderPasteContextMenuItemId
]
