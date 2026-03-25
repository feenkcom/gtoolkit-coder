Extension { #name : #OCArrayNode }

{ #category : #'*GToolkit-Coder' }
OCArrayNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	periods
		ifNotNil: [ periods := periods collect: [ :f | f + anInteger ] ].
	left ifNotNil: [ left := left + anInteger ].
	right ifNotNil: [ right := right + anInteger ]
]
