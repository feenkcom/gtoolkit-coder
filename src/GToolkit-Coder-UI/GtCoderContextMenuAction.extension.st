Extension { #name : #GtCoderContextMenuAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderContextMenuAction >> asBrMenuItemForCoderElement: aTextualCoderEditorElement [
	| aMenuItem |
	aMenuItem := GtCoderMenuActionItem new
			textualCoderEditorElement: aTextualCoderEditorElement;
			coderContextMenuAction: self;
			disableIf: [ self isDisabled ];
			yourself.

	self allowAltClick ifTrue: [ aMenuItem definition: [ self actionDefinition ] ].

	^ aMenuItem
]
