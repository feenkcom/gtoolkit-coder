Extension { #name : #GtSearchInstanceVariableReferenceFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchInstanceVariableReferenceFilter class >> filterDescriptorFor: aMethodsCoder [
	aMethodsCoder isForClass
		ifFalse: [ ^ nil ].
	^ GtFilterDescriptor
		creator: [ :value | 
			self
				forClassAndSubclasses: aMethodsCoder classOrMetaClass
				andVariable: value ]
		named: 'InstVar'
		order: 25
		completion:
			(GtStringsCompletionStrategy new
				completions: (GtPrefixTree withAll: aMethodsCoder classOrMetaClass allInstVarNames))
]
