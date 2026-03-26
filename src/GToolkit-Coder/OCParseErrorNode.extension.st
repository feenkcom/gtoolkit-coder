Extension { #name : #OCParseErrorNode }

{ #category : #'*GToolkit-Coder' }
OCParseErrorNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	start ifNotNil: [ start := start + anInteger ]
]
