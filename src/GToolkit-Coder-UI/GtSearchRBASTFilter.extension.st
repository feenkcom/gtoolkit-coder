Extension { #name : #GtSearchRBASTFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchRBASTFilter classSide >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		creator: [ :value | self sourceExpression: value ]
		named: 'AST'
		order: 100
]
