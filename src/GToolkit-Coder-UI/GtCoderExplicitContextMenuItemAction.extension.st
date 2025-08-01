Extension { #name : #GtCoderExplicitContextMenuItemAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderExplicitContextMenuItemAction >> asBrMenuItemForCoderElement: aTextualCoderEditorElement [
	<return: #BrMenuItem>
	| aMenuItem |
	aMenuItem := menuItemBlock
			cull: aTextualCoderEditorElement
			cull: aTextualCoderEditorElement textualCoderViewModel
			cull: self.

	aMenuItem ifNotNil: [ 
		self allowAltClick ifTrue: [ aMenuItem definition: [ self actionDefinition ] ].
		aMenuItem disableIf: [ self isDisabled ] ].

	^ aMenuItem
]
