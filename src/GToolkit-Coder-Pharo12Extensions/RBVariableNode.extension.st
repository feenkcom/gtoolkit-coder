Extension { #name : #RBVariableNode }

{ #category : #'*GToolkit-Coder-Pharo12Extensions' }
RBVariableNode >> gtIsLocal [
	^ (self whoDefines: self name) notNil
]

{ #category : #'*GToolkit-Coder-Pharo12Extensions' }
RBVariableNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	start ifNotNil: [ start := start + anInteger ]
]
