Extension { #name : #GtSearchInstanceVariableReferenceFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchInstanceVariableReferenceFilter >> highlighter [
	^ GtPharoVariableReferenceHighlighter forVariableName: variableName
]
