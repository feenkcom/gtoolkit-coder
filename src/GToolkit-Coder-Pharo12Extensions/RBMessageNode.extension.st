Extension { #name : #RBMessageNode }

{ #category : #'*GToolkit-Coder-Pharo12Extensions' }
RBMessageNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	keywordsPositions
		ifNotNil: [ keywordsPositions := keywordsPositions
				collect: [ :f | f + anInteger ] ]
]
