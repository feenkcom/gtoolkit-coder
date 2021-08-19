Extension { #name : 'RBAddPoolVariableChange' }

{ #category : '*GToolkit-Coder' }
RBAddPoolVariableChange >> changeObject [
	^ Smalltalk globals at: self variable asSymbol
]
