Extension { #name : #GtSearchLiteralStringFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchLiteralStringFilter >> highlighter [
	^ GtSubstringLiteralHighlighter 
		substring: self substring
		caseSensitive: self caseSensitive
]
