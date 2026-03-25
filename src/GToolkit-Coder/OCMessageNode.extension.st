Extension { #name : #OCMessageNode }

{ #category : #'*GToolkit-Coder' }
OCMessageNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	keywordsPositions
		ifNotNil: [ keywordsPositions := keywordsPositions
				collect: [ :f | f + anInteger ] ]
]
