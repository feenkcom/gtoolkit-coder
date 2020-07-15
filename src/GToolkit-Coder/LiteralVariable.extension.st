Extension { #name : #LiteralVariable }

{ #category : #'*GToolkit-Coder' }
LiteralVariable >> gtReferences [
	^ GtSearchReferencesFilter literal: self
]
