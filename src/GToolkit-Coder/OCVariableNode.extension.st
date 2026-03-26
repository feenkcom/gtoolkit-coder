Extension { #name : #OCVariableNode }

{ #category : #'*GToolkit-Coder' }
OCVariableNode >> gtIsLocal [
	^ (self whoDefines: self name) notNil
]

{ #category : #'*GToolkit-Coder' }
OCVariableNode >> gtMoveBy: anInteger [
	super gtMoveBy: anInteger.
	start ifNotNil: [ start := start + anInteger ]
]
