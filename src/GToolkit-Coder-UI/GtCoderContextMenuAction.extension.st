Extension { #name : #GtCoderContextMenuAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderContextMenuAction >> asBrMenuItemForCoderElement: aTextualCoderEditorElement [
	^ GtCoderMenuActionItem new
		textualCoderEditorElement: aTextualCoderEditorElement;
		coderContextMenuAction: self;
		yourself
]
