Extension { #name : #OCSequenceNode }

{ #category : #'*GToolkit-Coder' }
OCSequenceNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	periods ifNotNil: [ periods := periods collect: [ :f | f + anInteger ] ].
	leftBar ifNotNil: [ leftBar := leftBar + anInteger ].
	rightBar ifNotNil: [ rightBar := rightBar + anInteger ]
]
