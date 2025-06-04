Extension { #name : #GtCoderCustomAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderCustomAction >> buildElementIn: aCoderActionsElement [
	| anElement |
	anElement := (stencil cull: aCoderActionsElement) asElement.
	
	aCoderActionsElement initializeAltClick: self element: anElement.
	
	^ anElement
]
