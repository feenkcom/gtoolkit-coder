Extension { #name : #GtFullClassDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtFullClassDefinition >> editors [
	<return: #Collection of: #GtCodeDefinitionViewer>
	^ instanceSideDefinition editors , { classSideDefinition slots slotsEditor }
]

{ #category : #'*GToolkit-Coder-UI' }
GtFullClassDefinition >> readers [
	^ instanceSideDefinition readers
]
