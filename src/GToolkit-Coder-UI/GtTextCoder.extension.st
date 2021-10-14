Extension { #name : #GtTextCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtTextCoder >> asCoderUIModel [
	^ GtTextualCoderViewModel new coder: self
]
