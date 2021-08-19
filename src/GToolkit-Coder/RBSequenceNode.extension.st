Extension { #name : 'RBSequenceNode' }

{ #category : '*GToolkit-Coder' }
RBSequenceNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	periods ifNotNil: [ periods := periods collect: [ :f | f + anInteger ] ].
	leftBar ifNotNil: [ leftBar := leftBar + anInteger ].
	rightBar ifNotNil: [ rightBar := rightBar + anInteger ]
]
