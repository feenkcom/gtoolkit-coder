Extension { #name : #String }

{ #category : #'*GToolkit-Coder-UI' }
String >> asFilterModelItem [
	^ GtFilterModelStringItem new string: self
]
