Extension { #name : #GtCoderDropDownMenuAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderDropDownMenuAction >> buildElementIn: aCoderActionsElement [
	^ aCoderActionsElement newDropButtonMenuForAction: self
]
