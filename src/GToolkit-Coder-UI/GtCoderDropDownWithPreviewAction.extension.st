Extension { #name : #GtCoderDropDownWithPreviewAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderDropDownWithPreviewAction >> buildElementIn: aCoderActionsElement [
	| aButton |
	aButton := GtPreviewChangeButton new
		id: self id;
		icon: self icon;
		label: self title;
		changeAction: self changeAction;
		changeStencil:
			(self changeStencil isBlock
				ifTrue: [ self changeStencil asStencil arguments: {aCoderActionsElement} ]
				ifFalse: [ self changeStencil ]).
				
	aCoderActionsElement initializeAltClick: self element: aButton.
				
	^ aButton
]
