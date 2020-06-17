Extension { #name : #String }

{ #category : #'*GToolkit-Coder' }
String >> gtASTMatches [
	^ GtSearchASTFilter sourceExpression: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtASTMethodMatches [
	^ GtSearchASTFilter sourceMethod: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtClassMatches [
	^ GtSearchMethodsWithClassPatternFilter pattern: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtMethodCategories [
	^ self gtMethodProtocols
]

{ #category : #'*GToolkit-Coder' }
String >> gtMethodProtocols [
	^ GtSearchMethodCategoryFilter forCategory: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtPackageMatches [
	^ GtSearchMethodsWithPackagePatternFilter pattern: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtReferences [
	^ GtSearchReferencesFilter literal: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtSubstringMatch [
	^ GtSubstringFilter substring: self
]
