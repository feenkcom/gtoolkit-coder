Extension { #name : #GtSearchInstanceVariableReferenceFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchInstanceVariableReferenceFilter >> highlighter [
	^ GtVariableReferenceHighlighter forVariableName: variableName
]
