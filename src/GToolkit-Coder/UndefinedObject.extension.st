Extension { #name : #UndefinedObject }

{ #category : #'*GToolkit-Coder' }
UndefinedObject >> gtReferences [
	^ GtSearchReferencesFilter literal: self
]
