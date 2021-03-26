Extension { #name : #GtProcessCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtProcessCoder >> asCoderUIModel [
	^ GtProcessCoderViewModel new coder: self
]
