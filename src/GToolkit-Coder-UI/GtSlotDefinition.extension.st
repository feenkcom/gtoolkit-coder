Extension { #name : #GtSlotDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtSlotDefinition >> browseFrom: anEvent [
	anEvent currentTarget phlow spawnObject: self
]

{ #category : #'*GToolkit-Coder-UI' }
GtSlotDefinition >> browseReferencesFrom: anEvent [
	parent classOrMetaClass
		ifNotNil: [ :class | 
			anEvent currentTarget phlow
				spawnObject:
					(GtSearchInstanceVariableReferenceFilter
						forClassAndSubclasses: class
						andVariable: self name) ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtSlotDefinition >> inspectFrom: anEvent [
	parent isForMetaclass
		ifFalse: [ ^ self ].
	anEvent currentTarget phlow spawnObject: self value
]
