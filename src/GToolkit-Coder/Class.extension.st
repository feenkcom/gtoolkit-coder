Extension { #name : #Class }

{ #category : #'*GToolkit-Coder' }
Class >> gtReferences [
	^ GtCoderReferencesFilter literal: self binding
]
