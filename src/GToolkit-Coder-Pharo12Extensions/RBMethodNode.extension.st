Extension { #name : #RBMethodNode }

{ #category : #'*GToolkit-Coder-Pharo12Extensions' }
RBMethodNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	keywordsPositions
		ifNotNil: [ keywordsPositions := keywordsPositions
				collect: [ :f | f + anInteger ] ]
]
