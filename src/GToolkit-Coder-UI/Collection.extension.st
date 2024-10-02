Extension { #name : #Collection }

{ #category : #'*GToolkit-Coder-UI' }
Collection >> asFilterModelItemsBuilder [
	^ GtFilterModelExplicitItemsBuilder new items: self
]
