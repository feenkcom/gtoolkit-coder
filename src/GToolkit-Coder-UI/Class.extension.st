Extension { #name : #Class }

{ #category : #'*GToolkit-Coder-UI' }
Class >> asFilterModelItem [
	^ GtFilterShortListModelClassItem new itemClass: self
]
