Extension { #name : #GtSearchLiteralStringFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchLiteralStringFilter >> highlighter [
	^ GtPharoSubstringLiteralHighlighter 
		substring: self substring
		caseSensitive: self caseSensitive
]
