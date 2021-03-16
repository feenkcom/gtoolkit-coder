Extension { #name : #GtSearchCommentsFilter }

{ #category : #'*GToolkit-Coder-AddOns' }
GtSearchCommentsFilter >> highlighter [
	^ GtPharoCommentsReferenceHighlighter new commentsFilter: self
]
