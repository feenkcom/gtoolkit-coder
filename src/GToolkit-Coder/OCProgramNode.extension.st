Extension { #name : #OCProgramNode }

{ #category : #'*GToolkit-Coder' }
OCProgramNode >> gtMoveAllBy: anInteger [
	self gtMoveBy: anInteger.
	self children do: [ :e | e gtMoveAllBy: anInteger ]
]

{ #category : #'*GToolkit-Coder' }
OCProgramNode >> gtMoveBy: anInteger [
	self comments do: [ :f | f with: f contents at: f start + anInteger ]
]

{ #category : #'*GToolkit-Coder' }
OCProgramNode >> withAllParentsDo: aBlock [
	| node |
	node := self.
	[ node notNil ]
		whileTrue: [ aBlock value: node.
			node := node parent ]
]
