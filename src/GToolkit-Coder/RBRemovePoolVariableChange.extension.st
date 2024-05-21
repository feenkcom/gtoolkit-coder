Extension { #name : #RBRemovePoolVariableChange }

{ #category : #'*GToolkit-Coder' }
RBRemovePoolVariableChange >> changeObject [
	<gtPharoPatch: #Pharo>
	
	^ Smalltalk globals at: self variable asSymbol
]
