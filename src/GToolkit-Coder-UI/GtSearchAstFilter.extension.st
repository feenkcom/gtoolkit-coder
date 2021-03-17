Extension { #name : #GtSearchAstFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchAstFilter class >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		creator: [ :value | self sourceExpression: value ]
		named: 'AST'
		order: 100
]
