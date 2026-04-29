Extension { #name : #RBLiteralNode }

{ #category : #'*GToolkit-Coder-Pharo12Extensions' }
RBLiteralNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	start ifNotNil: [ start := start + anInteger ].
	stop ifNotNil: [ stop := stop + anInteger ]
]
