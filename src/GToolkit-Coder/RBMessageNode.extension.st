Extension { #name : #RBMessageNode }

{ #category : #'*GToolkit-Coder' }
RBMessageNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	keywordsPositions
		ifNotNil: [ keywordsPositions := keywordsPositions
				collect: [ :f | f + anInteger ] ]
]
