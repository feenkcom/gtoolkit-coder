Extension { #name : #GtSearchReferencesFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchReferencesFilter >> highlighter [
	((self object isKindOf: Association) and: [ self object key isSymbol ])
				ifTrue: [ ^ GtVariableReferenceHighlighter forVariableName: self object key ].
	self object isLiteral ifTrue: [ ^ GtSelectorReferenceAndLiteralHighlighter forSelector: self object ].
	^ nil
]
