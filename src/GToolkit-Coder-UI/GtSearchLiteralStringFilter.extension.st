Extension { #name : #GtSearchLiteralStringFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchLiteralStringFilter >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		creator: [ :value | self substring: value ]
		named: 'Substring Literal'
		order: 91
]
