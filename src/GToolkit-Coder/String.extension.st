Extension { #name : #String }

{ #category : #'*GToolkit-Coder' }
String >> gtASTMatches [
	^ GtSearchAstFilter sourceExpression: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtASTMethodMatches [
	^ GtSearchAstFilter sourceMethod: self
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
String >> gtSubstringLiteralCaseSensitiveMatch [
	^ GtSearchLiteralStringFilter substring: self caseSensitive: true
]

{ #category : #'*GToolkit-Coder' }
String >> gtSubstringLiteralMatch [
	^ GtSearchLiteralStringFilter substring: self
]

{ #category : #'*GToolkit-Coder' }
String >> gtSubstringMatch [
	^ GtSubstringFilter substring: self
]
