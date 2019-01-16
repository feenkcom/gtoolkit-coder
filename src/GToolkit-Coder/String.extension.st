Extension { #name : #String }

{ #category : #'*GToolkit-Coder' }
String >> gtASTMatches [
	^ GtCoderASTFilter sourceExpression: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtPackageMatches [
	^ GtCoderPackagePatternFilter pattern: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtReferences [
	^ GtCoderReferencesFilter literal: self
]
