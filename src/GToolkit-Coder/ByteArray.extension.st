Extension { #name : #ByteArray }

{ #category : #'*GToolkit-Coder' }
ByteArray >> gtReferences [
	^ GtCoderReferencesFilter literal: self
]
