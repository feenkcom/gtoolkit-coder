Extension { #name : #GtVariableDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtVariableDefinition >> browseFrom: anEvent [
	anEvent currentTarget phlow spawnObject: self
]

{ #category : #'*GToolkit-Coder-UI' }
GtVariableDefinition >> browseReferencesFrom: anEvent [
	parent classOrMetaClass
		ifNotNil: [ :class | 
			(class bindingOf: self originalName)
				ifNotNil: [ :binding |
					anEvent currentTarget phlow
						spawnObject: (GtSearchReferencesFilter literal: binding) ] ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtVariableDefinition >> inspectFrom: anEvent [
	anEvent currentTarget phlow spawnObject: self value
]
