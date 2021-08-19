Extension { #name : 'RBBlockNode' }

{ #category : '*GToolkit-Coder' }
RBBlockNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	colons ifNotNil: [ colons := colons collect: [ :f | f + anInteger ] ].
	left ifNotNil: [ left := left + anInteger ].
	right ifNotNil: [ right := right + anInteger ].
	bar ifNotNil: [ bar := bar + anInteger ]
]
