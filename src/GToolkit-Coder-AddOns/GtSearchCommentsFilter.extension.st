Extension { #name : #GtSearchCommentsFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchCommentsFilter >> highlighter [
	^ GtCommentsReferenceHighlighter new commentsFilter: self
]
