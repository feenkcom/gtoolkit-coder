Extension { #name : #Number }

{ #category : #'*GToolkit-Coder' }
Number >> gtReferences [
	^ GtCoderReferencesFilter literal: self
]
