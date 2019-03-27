Extension { #name : #RBArrayNode }

{ #category : #'*GToolkit-Coder' }
RBArrayNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	periods
		ifNotNil: [ periods := periods collect: [ :f | f + anInteger ] ].
	left ifNotNil: [ left := left + anInteger ].
	right ifNotNil: [ right := right + anInteger ]
]
