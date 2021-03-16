Extension { #name : #GtSearchPragmasFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchPragmasFilter >> highlighter [
	^ GtPharoPragmaHighlighter forPragma: symbol
]
