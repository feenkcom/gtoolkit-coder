Extension { #name : #Class }

{ #category : #'*GToolkit-Coder' }
Class >> gtReferences [
	^ GtSearchReferencesFilter literal: self binding
]
