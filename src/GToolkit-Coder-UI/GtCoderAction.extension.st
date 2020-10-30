Extension { #name : #GtCoderAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderAction >> buildElementIn: aCoderActionsElement [
	^ aCoderActionsElement newButtonForAction: self
]
