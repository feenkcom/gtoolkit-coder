Extension { #name : #String }

{ #category : #'*GToolkit-Coder-UI' }
String >> asFilterModelItem [
	^ GtFilterShortListModelStringItem new string: self
]
