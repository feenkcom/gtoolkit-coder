Extension { #name : #Symbol }

{ #category : #'*GToolkit-Coder' }
Symbol >> asGlobalVariable [
	^ Smalltalk globals associationAt: self
]

{ #category : #'*GToolkit-Coder' }
Symbol >> gtImplementors [
	^ GtSearchImplementorsFilter selector: self
]

{ #category : #'*GToolkit-Coder' }
Symbol >> gtPragmas [
	^ GtSearchPragmasFilter forPragma: self
]

{ #category : #'*GToolkit-Coder' }
Symbol >> gtReferences [
	^ GtSearchReferencesFilter literal: self
]

{ #category : #'*GToolkit-Coder' }
Symbol >> gtSenders [
	^ self gtReferences
]
