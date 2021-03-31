Extension { #name : #RBRemovePoolVariableChange }

{ #category : #'*GToolkit-Coder' }
RBRemovePoolVariableChange >> changeObject [
	^ Smalltalk globals at: self variable asSymbol
]
