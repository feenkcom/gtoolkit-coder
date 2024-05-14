Trait {
	#name : #TGtSourceCoderEvaluatedCode,
	#category : #'GToolkit-Coder-Coders - Evaluation'
}

{ #category : #accessing }
TGtSourceCoderEvaluatedCode >> findRelevantContextInStack: aStack [
	"Return a stack context that corresponds to a given evaluated code."

	<return: #Context or: nil>
	^ nil
]

{ #category : #accessing }
TGtSourceCoderEvaluatedCode >> findSourceAstForContext: aContext [
	"Return an AST node that corresponds to a given executed code."

	<return: #RBMessageNode>
	^ nil
]
