Extension { #name : #GtSearchClassVariableReferenceFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchClassVariableReferenceFilter class >> filterDescriptorFor: aMethodsCoder [
	aMethodsCoder isForClass
		ifFalse: [ ^ nil ].
	^ GtFilterDescriptor
		creator:
			[ :value | self forClass: aMethodsCoder classOrMetaClass andVariable: value ]
		named: 'ClassVar'
		order: 25
		completion:
			(GtStringsCompletionStrategy new
				completions:
					(GtPrefixTree withAll: aMethodsCoder classOrMetaClass allClassVarNames))
]
