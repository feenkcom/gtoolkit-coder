Extension { #name : #RBPragmaNode }

{ #category : #'*GToolkit-Coder' }
RBPragmaNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	keywordsPositions
		ifNotNil: [ keywordsPositions := keywordsPositions collect: [ :f | f + anInteger ] ].
	left ifNotNil: [ left := left + anInteger ].
	right ifNotNil: [ right := right + anInteger ]
]
