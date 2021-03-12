Extension { #name : #GtTextCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtTextCoder >> asCoderUIModel [
	^ GtSourceCoderViewModel new coder: self
]
