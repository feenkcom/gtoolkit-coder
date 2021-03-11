Extension { #name : #GtTextCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtTextCoder >> asCoderUIModel [
	^ GtSourceCoderUIModel new coder: self
]
