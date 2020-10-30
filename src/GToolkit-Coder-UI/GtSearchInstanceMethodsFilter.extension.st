Extension { #name : #GtSearchInstanceMethodsFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchInstanceMethodsFilter class >> filterDescriptorFor: aMethodsCoder [
	^ (GtFilterDescriptor
		creator: [ :value | self new ]
		named: 'Instance Methods'
		order: 16)
		valueNotRequired;
		yourself
]
