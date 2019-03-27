Extension { #name : #RBValueNode }

{ #category : #'*GToolkit-Coder' }
RBValueNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	parentheses ifNotNil: [ parentheses := parentheses collect: [ :f | f + anInteger ] ].
]
