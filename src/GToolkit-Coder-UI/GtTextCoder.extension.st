Extension { #name : #GtTextCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtTextCoder >> asCoderViewModel [
	^ GtTextualCoderViewModel new coder: self
]
