Extension { #name : #Symbol }

{ #category : #'*GToolkit-Coder' }
Symbol >> asGlobalVariable [
	^ Smalltalk globals associationAt: self
]

{ #category : #'*GToolkit-Coder' }
Symbol >> gtImplementors [
	^ GtCoderImplementorsFilter selector: self
]

{ #category : #'*GToolkit-Coder' }
Symbol >> gtPragmas [
	^ GtCoderPragmasFilter forPragma: self
]

{ #category : #'*GToolkit-Coder' }
Symbol >> gtReferences [
	^ GtCoderReferencesFilter literal: self
]
