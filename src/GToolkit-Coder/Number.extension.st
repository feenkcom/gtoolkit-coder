Extension { #name : #Number }

{ #category : #'*GToolkit-Coder' }
Number >> gtReferences [
	^ GtSearchReferencesFilter literal: self
]
