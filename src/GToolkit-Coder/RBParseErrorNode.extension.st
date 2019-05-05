Extension { #name : #RBParseErrorNode }

{ #category : #'*GToolkit-Coder' }
RBParseErrorNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	start ifNotNil: [ start := start + anInteger ]
]
