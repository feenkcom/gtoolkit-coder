Extension { #name : #GtSearchMethodCategoryFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchMethodCategoryFilter class >> filterDescriptorFor: aMethodsCoder [
	^ GtFilterDescriptor
		creator: [ :value | self forCategory: value ]
		named: 'Category'
		order: 15
		completion:
			(GtStringsCompletionStrategy new completions: aMethodsCoder categories)
		emptyDefaultValue: 'All'
]
