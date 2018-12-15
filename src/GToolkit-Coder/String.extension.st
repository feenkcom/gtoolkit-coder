Extension { #name : #String }

{ #category : #'*GToolkit-Coder' }
String >> gtASTMatches [
	^ GtCoderASTFilter sourceExpression: self
]
