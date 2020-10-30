Extension { #name : #GtBlockCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtBlockCoder >> asCoderUIModel [
	^ GtSourceCoderUIModel new coder: self
]
