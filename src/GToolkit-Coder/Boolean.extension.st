Extension { #name : #Boolean }

{ #category : #'*GToolkit-Coder' }
Boolean >> gtReferences [
	^ GtSearchReferencesFilter literal: self
]
