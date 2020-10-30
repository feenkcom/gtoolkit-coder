Extension { #name : #GtSubstringFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSubstringFilter >> highlighter [
	^ GtSubstringHighlighter substring: self substring
]
