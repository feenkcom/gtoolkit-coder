Extension { #name : #GtSearchASTFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchASTFilter class >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		creator: [ :value | self sourceExpression: value ]
		named: 'AST'
		order: 100
]
