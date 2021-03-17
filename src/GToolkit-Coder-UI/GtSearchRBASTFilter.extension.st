Extension { #name : #GtSearchRBASTFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchRBASTFilter class >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		creator: [ :value | self sourceExpression: value ]
		named: 'AST'
		order: 100
]
