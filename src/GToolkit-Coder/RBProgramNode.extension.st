Extension { #name : #RBProgramNode }

{ #category : #'*GToolkit-Coder' }
RBProgramNode >> gtASTMatches [
	^ GtCoderASTFilter ast: self
]
