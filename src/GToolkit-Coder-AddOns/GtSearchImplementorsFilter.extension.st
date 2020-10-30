Extension { #name : #GtSearchImplementorsFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchImplementorsFilter >> highlighter [
	^ GtImplementorHighlighter forSelector: selector
]
