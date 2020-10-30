Extension { #name : #GtCoderDropDownAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderDropDownAction >> buildElementIn: aCoderActionsElement [
	^ aCoderActionsElement newDropButtonForAction: self
]
