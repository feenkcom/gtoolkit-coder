Extension { #name : #GtSearchAstFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchAstFilter classSide >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		creator: [ :value | self sourceExpression: value ]
		named: 'AST'
		order: 100
]
