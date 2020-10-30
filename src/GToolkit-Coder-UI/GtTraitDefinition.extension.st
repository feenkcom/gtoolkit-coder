Extension { #name : #GtTraitDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtTraitDefinition >> browseFrom: anEvent [
	self class environment
		at: self name
		ifPresent: [ :aTrait | anEvent currentTarget phlow spawnTool: (GtClassCoderTool observedClass: aTrait) ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtTraitDefinition >> editors [
	<return: #Collection of: #GtCodeDefinitionViewer>

	^ { 
		self category categoryEditor.
		self traits traitsEditor.
		self slots slotsEditor.
	}
]

{ #category : #'*GToolkit-Coder-UI' }
GtTraitDefinition >> readers [
	<return: #Collection of: #GtCodeDefinitionViewer>

	^ { 
		self category categoryReader.
	}
]
