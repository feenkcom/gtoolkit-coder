Extension { #name : #String }

{ #category : #'*GToolkit-Coder' }
String >> gtASTMatches [
	^ GtSearchASTFilter sourceExpression: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtClassMatches [
	^ GtSearchMethodsWithClassPatternFilter pattern: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtPackageMatches [
	^ GtSearchMethodsWithPackagePatternFilter pattern: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtReferences [
	^ GtSearchReferencesFilter literal: self
]
