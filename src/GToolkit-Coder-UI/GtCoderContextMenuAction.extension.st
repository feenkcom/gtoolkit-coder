Extension { #name : #GtCoderContextMenuAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderContextMenuAction >> asBrMenuItemForCoderElement: aTextualCoderEditorElement [
	^ GtCoderMenuActionItem new
		textualCoderEditorElement: aTextualCoderEditorElement;
		coderContextMenuAction: self;
		disableIf: [ self isDisabled ];
		definition: [ self allowAltClick
				ifTrue: [ self actionDefinition isDefined
						ifTrue: [ self actionDefinition ]
						ifFalse: [ nil ] ]
				ifFalse: [ nil ] ];
		yourself
]
