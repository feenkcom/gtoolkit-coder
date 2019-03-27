Extension { #name : #RBCascadeNode }

{ #category : #'*GToolkit-Coder' }
RBCascadeNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	semicolons
		ifNotNil: [ semicolons := semicolons collect: [ :f | f + anInteger ] ]
]
