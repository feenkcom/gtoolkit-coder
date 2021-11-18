Extension { #name : #GtSearchBinaryFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchBinaryFilter >> highlighter [
	^ left highlighter
		ifNil: [ right highlighter ]
		ifNotNil: [ :lh | 
			right highlighter
				ifNil: [ lh ]
				ifNotNil:
					[ :rh | GtCompositeHighlighter forHighlighters: (Array with: lh with: rh) ] ]
]
