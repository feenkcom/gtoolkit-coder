Extension { #name : #RBAssignmentNode }

{ #category : #'*GToolkit-Coder' }
RBAssignmentNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	assignment ifNotNil: [ assignment := assignment + anInteger ]
]
