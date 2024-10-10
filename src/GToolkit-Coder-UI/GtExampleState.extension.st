Extension { #name : #GtExampleState }

{ #category : #'*GToolkit-Coder-UI' }
GtExampleState >> asFilterModelItem [
	^ GtFilterModelExampleResultStateItem new resultState: self
]
