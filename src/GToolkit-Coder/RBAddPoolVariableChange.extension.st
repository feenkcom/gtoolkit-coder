Extension { #name : #RBAddPoolVariableChange }

{ #category : #'*GToolkit-Coder' }
RBAddPoolVariableChange >> changeObject [
	<gtPharoPatch: #Pharo>
	
	^ Smalltalk globals at: self variable asSymbol
]
