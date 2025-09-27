Extension { #name : #GtCoderDropDownMenuAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderDropDownMenuAction >> asBrMenuItemForCoderElement: aTextualCoderEditorElement [
	| aMenuItem aSubMenu |
	aSubMenu := self menuBlock
			cull: aTextualCoderEditorElement textualCoderViewModel
			cull: aTextualCoderEditorElement.
	aSubMenu ifNil: [ ^ nil ].
	
	aMenuItem := GtCoderMenuSubmenuItem new
		textualCoderEditorElement: aTextualCoderEditorElement;
		coderContextMenuAction: self;
		disableIf: [ self isDisabled ];
		submenu: aSubMenu.

	self allowAltClick ifTrue: [ aMenuItem definition: [ self actionDefinition ] ].

	^ aMenuItem
]

{ #category : #'*GToolkit-Coder-UI' }
GtCoderDropDownMenuAction >> buildElementIn: aCoderActionsElement [
	^ aCoderActionsElement newDropButtonMenuForAction: self
]
