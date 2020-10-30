Extension { #name : #GtSearchPragmasFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchPragmasFilter >> highlighter [
	^ GtPragmaHighlighter forPragma: symbol
]
