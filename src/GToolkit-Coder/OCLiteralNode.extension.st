Extension { #name : #OCLiteralNode }

{ #category : #'*GToolkit-Coder' }
OCLiteralNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	start ifNotNil: [ start := start + anInteger ].
	stop ifNotNil: [ stop := stop + anInteger ]
]
