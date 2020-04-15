Extension { #name : #RBProgramNode }

{ #category : #'*GToolkit-Coder' }
RBProgramNode >> gtASTMatches [
	^ GtSearchASTFilter ast: self
]

{ #category : #'*GToolkit-Coder' }
RBProgramNode >> gtMoveAllBy: anInteger [
	self gtMoveBy: anInteger.
	self children do: [ :e | e gtMoveAllBy: anInteger ]
]

{ #category : #'*GToolkit-Coder' }
RBProgramNode >> gtMoveBy: anInteger [
	self comments do: [ :f | f with: f contents at: f start + anInteger ]
]

{ #category : #'*GToolkit-Coder' }
RBProgramNode >> withAllParentsDo: aBlock [
	| node |
	node := self.
	[ node notNil ]
		whileTrue: [ aBlock value: node.
			node := node parent ]
]
