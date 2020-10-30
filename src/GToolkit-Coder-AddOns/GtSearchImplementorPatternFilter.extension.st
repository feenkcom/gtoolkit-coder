Extension { #name : #GtSearchImplementorPatternFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchImplementorPatternFilter >> highlighter [
	pattern isEmpty
		ifTrue: [ ^ super highlighter ].
	^ GtImplementorPatternHighlighter forPattern: pattern
]
