Extension { #name : #Boolean }

{ #category : #'*GToolkit-Coder' }
Boolean >> gtReferences [
	^ GtCoderReferencesFilter literal: self
]
