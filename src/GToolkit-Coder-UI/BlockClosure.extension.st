Extension { #name : #BlockClosure }

{ #category : #'*GToolkit-Coder-UI' }
BlockClosure >> asFilterModelItemsBuilder [
	^ GtFilterModelValuableItemsBuilder new valuable: self
]
