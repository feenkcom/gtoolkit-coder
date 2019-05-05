Extension { #name : #RBCascadeNode }

{ #category : #'*GToolkit-Coder' }
RBCascadeNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	(messages size - 1) timesRepeat: [ self receiver gtMoveBy: 0 - anInteger ].
	semicolons
		ifNotNil: [ semicolons := semicolons collect: [ :f | f + anInteger ] ]
]
