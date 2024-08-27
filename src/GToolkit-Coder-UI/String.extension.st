Extension { #name : #String }

{ #category : #'*GToolkit-Coder-UI' }
String >> asFilterShortListModelItem [
	^ GtFilterShortListModelStringItem new string: self
]
