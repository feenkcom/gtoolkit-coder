Extension { #name : #GlobalVariable }

{ #category : #'*GToolkit-Coder' }
GlobalVariable >> gtReferences [
	^ GtSearchReferencesFilter literal: self
]
