Extension { #name : #GtMethodsCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtMethodsCoder >> asCoderUIModel [
	^ GtMethodsCoderViewModel new coder: self
]
