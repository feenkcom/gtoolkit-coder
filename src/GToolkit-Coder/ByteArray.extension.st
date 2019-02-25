Extension { #name : #ByteArray }

{ #category : #'*GToolkit-Coder' }
ByteArray >> gtReferences [
	^ GtSearchReferencesFilter literal: self
]
