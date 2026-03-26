Extension { #name : #OCBlockNode }

{ #category : #'*GToolkit-Coder' }
OCBlockNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	colons ifNotNil: [ colons := colons collect: [ :f | f + anInteger ] ].
	left ifNotNil: [ left := left + anInteger ].
	right ifNotNil: [ right := right + anInteger ].
	bar ifNotNil: [ bar := bar + anInteger ]
]
