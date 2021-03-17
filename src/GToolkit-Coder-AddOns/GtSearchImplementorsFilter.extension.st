Extension { #name : #GtSearchImplementorsFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchImplementorsFilter >> highlighter [
	^ GtPharoImplementorHighlighter forSelector: selector
]
