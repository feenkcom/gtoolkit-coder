Extension { #name : #GtCoderExplicitContextMenuItemAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderExplicitContextMenuItemAction >> asBrMenuItemForCoderElement: aTextualCoderEditorElement [
	<return: #BrMenuItem>
	^ menuItemBlock 
		cull: aTextualCoderEditorElement 
		cull: aTextualCoderEditorElement textualCoderViewModel
		cull: self
]
