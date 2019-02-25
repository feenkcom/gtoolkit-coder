Extension { #name : #RBProgramNode }

{ #category : #'*GToolkit-Coder' }
RBProgramNode >> gtASTMatches [
	^ GtSearchASTFilter ast: self
]
