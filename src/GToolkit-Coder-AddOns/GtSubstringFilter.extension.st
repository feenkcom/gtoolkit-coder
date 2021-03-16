Extension { #name : #GtSubstringFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSubstringFilter >> highlighter [
	^ GtPharoSubstringHighlighter substring: self substring
]
