Extension { #name : #GtSearchReferencesFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchReferencesFilter >> highlighter [
	((self object isKindOf: Association) and: [ self object key isSymbol ])
				ifTrue: [ ^ GtPharoVariableReferenceHighlighter forVariableName: self object key ].
	self object isLiteral ifTrue: [ ^ GtPharoSelectorReferenceAndLiteralHighlighter forSelector: self object ].
	^ nil
]
