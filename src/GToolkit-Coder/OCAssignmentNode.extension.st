Extension { #name : #OCAssignmentNode }

{ #category : #'*GToolkit-Coder' }
OCAssignmentNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	assignment ifNotNil: [ assignment := assignment + anInteger ]
]
