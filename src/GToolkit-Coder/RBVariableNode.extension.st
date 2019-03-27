Extension { #name : #RBVariableNode }

{ #category : #'*GToolkit-Coder' }
RBVariableNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	start ifNotNil: [ start := start + anInteger ]
]
