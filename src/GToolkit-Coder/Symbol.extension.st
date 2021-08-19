Extension { #name : 'Symbol' }

{ #category : '*GToolkit-Coder' }
Symbol >> asGlobalVariable [
	^ Smalltalk globals associationAt: self
]

{ #category : '*GToolkit-Coder' }
Symbol >> gtSenders [
	^ self gtReferences
]
