Extension { #name : #Character }

{ #category : #'*GToolkit-Coder' }
Character >> gtReferences [
	^ GtSearchReferencesFilter literal: self
]
