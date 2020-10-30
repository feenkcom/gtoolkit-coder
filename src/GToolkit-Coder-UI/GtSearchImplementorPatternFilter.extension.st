Extension { #name : #GtSearchImplementorPatternFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchImplementorPatternFilter class >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		creator: [ :value | self pattern: value ]
		named: 'Implementor'
		order: 10
		completion:
			(GtStringsCompletionStrategy new
				completions: aMethodsCoder selectorNames)
]
