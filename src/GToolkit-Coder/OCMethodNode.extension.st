Extension { #name : #OCMethodNode }

{ #category : #'*GToolkit-Coder' }
OCMethodNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	keywordsPositions
		ifNotNil: [ keywordsPositions := keywordsPositions
				collect: [ :f | f + anInteger ] ]
]
