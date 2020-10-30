Extension { #name : #GtSearchASTFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchASTFilter >> highlighter [
	^ GtASTPatternHighlighter ast: ast
]
