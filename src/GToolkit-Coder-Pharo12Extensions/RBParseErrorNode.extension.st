Extension { #name : #RBParseErrorNode }

{ #category : #'*GToolkit-Coder-Pharo12Extensions' }
RBParseErrorNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	start ifNotNil: [ start := start + anInteger ]
]
