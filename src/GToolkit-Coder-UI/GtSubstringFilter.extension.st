Extension { #name : #GtSubstringFilter }

{ #category : #'*GToolkit-Coder-UI' }
GtSubstringFilter >> filterDescriptor2For: aMethodsCoder [
	^ (super filterDescriptor2For: aMethodsCoder)
		ifNotNil: [ :aFilterModel | aFilterModel text: self substring ]
]
