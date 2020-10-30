Extension { #name : #GtPoolDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtPoolDefinition >> browseFrom: anEvent [
	self class environment
		at: self name
		ifPresent: [ :aPool | anEvent currentTarget phlow spawnTool: (GtClassCoderTool observedClass: aPool) ]
]
