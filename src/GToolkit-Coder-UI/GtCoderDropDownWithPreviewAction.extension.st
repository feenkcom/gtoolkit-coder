Extension { #name : #GtCoderDropDownWithPreviewAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderDropDownWithPreviewAction >> buildElementIn: aCoderActionsElement [
	^ GtPreviewChangeButton new
		icon: self icon;
		label: self title;
		changeAction: self changeAction;
		changeStencil:
			(self changeStencil isBlock
				ifTrue: [ self changeStencil asStencil arguments: {aCoderActionsElement} ]
				ifFalse: [ self changeStencil ])
]
