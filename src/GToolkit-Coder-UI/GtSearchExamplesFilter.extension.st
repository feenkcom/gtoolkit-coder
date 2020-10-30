Extension { #name : #GtSearchExamplesFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchExamplesFilter class >> filterDescriptorFor: aMethodsCoder [
	^ (GtFilterDescriptor
		creator: [ :value | self new
			resultStateString: value;
			coder: aMethodsCoder ]
		named: 'Examples'
		order: 12
		completion: (GtStringsCompletionStrategy new completions: 
			(GtPrefixTree withAll: GtFilterExampleState default allLabels)) 
		emptyDefaultValue: self defaultState label)
		beNotDefault
]
