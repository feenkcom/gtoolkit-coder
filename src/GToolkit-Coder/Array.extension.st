Extension { #name : #Array }

{ #category : #'*GToolkit-Coder' }
Array >> gtReferences [
	^ GtCoderReferencesFilter literal: self
]
