Extension { #name : #Array }

{ #category : #'*GToolkit-Coder' }
Array >> gtReferences [
	^ GtSearchReferencesFilter literal: self
]
