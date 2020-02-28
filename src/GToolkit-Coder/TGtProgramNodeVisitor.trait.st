Trait {
	#name : #TGtProgramNodeVisitor,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #category }
TGtProgramNodeVisitor >> visitArgumentNode: aNode [
	^ self visitVariableNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitArrayNode: aNode [
	^ self visitValueNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitAssignmentNode: aNode [
	^ self visitValueNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitBlockNode: aNode [
	^ self visitValueNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitCascadeNode: aNode [
	^ self visitValueNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitComment: aNode [
	^ self visitNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitGlobalNode: aNode [
	^ self visitVariableNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitInstanceVariableNode: aNode [
	^ self visitVariableNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitLiteralArrayNode: aNode [
	^ self visitLiteralNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitLiteralNode: aNode [
	^ self visitValueNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitLiteralValueNode: aNode [
	^ self visitLiteralNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitLiteralVariableNode: aNode [
	^ self visitProgramNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitMessageNode: aNode [
	^ self visitMessageNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitMethodNode: aNode [
	^ self visitProgramNode: aNode.
]

{ #category : #visiting }
TGtProgramNodeVisitor >> visitNode: aNode [
]

{ #category : #category }
TGtProgramNodeVisitor >> visitParseErrorNode: aNode [
	^ self visitValueNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitPatternBlockNode: aNode [
	^ self visitBlockNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitPatternMessageNode: aNode [
	^ self visitMessageNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitPatternMethodNode: aNode [
	^ self visitMethodNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitPatternPragmaNode: aNode [
	^ self visitPragmaNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitPatternVariableNode: aNode [
	^ self visitVariableNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitPatternWrapperBlockNode: aNode [
	^ self visitPatternBlockNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitPragmaNode: aNode [
	^ self visitProgramNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitProgramNode: aNode [
	^ self visitNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitReturnNode: aNode [
	^ self visitProgramNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitSelfNode: aNode [
	^ self visitVariableNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitSequenceNode: aNode [
	^ self visitProgramNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitSlotInitializationNode: aNode [
	^ self visitNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitStoreIntoTempNode: aNode [
	^ self visitVariableNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitStorePopIntoTempNode: aNode [
	^ self visitVariableNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitSuperNode: aNode [
	^ self visitVariableNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitTemporaryNode: aNode [
	^ self visitVariableNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitThisContextNode: aNode [
	^ self visitVariableNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitValueNode: aNode [
	^ self visitProgramNode: aNode.
]

{ #category : #category }
TGtProgramNodeVisitor >> visitVariableNode: aNode [
	^ self visitValueNode: aNode.
]
