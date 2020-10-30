Extension { #name : #GtSearchMethodsWithClassPatternFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSearchMethodsWithClassPatternFilter class >> filterDescriptorFor: aMethodsCoder [
	aMethodsCoder isForClass
		ifTrue: [ ^ nil ].
	^ GtFilterDescriptor
		creator: [ :value | self pattern: value ]
		named: 'Class'
		order: 20
		completion:
			(GtStringsCompletionStrategy new completions: aMethodsCoder classNames)
]
