Extension { #name : #OCValueNode }

{ #category : #'*GToolkit-Coder' }
OCValueNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	parentheses ifNotNil: [ parentheses := parentheses collect: [ :f | f + anInteger ] ].
]
