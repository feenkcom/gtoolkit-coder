Extension { #name : #GtCategoryDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtCategoryDefinition >> categoryEditor [
	<return: #GtCodeDefinitionViewer>
	
	^ GtCodeDefinitionCompositeEntityViewer withAll: {
		self package packageEditor.
		self tag tagEditor }
]

{ #category : #'*GToolkit-Coder-UI' }
GtCategoryDefinition >> categoryReader [
	<return: #GtCodeDefinitionViewer>
	
	^ GtCodeDefinitionCompositeEntityViewer withAll: {
		self package packageReader.
		self tag tagReader }
]

{ #category : #'*GToolkit-Coder-UI' }
GtCategoryDefinition >> editors [
	^ { self categoryEditor }
]

{ #category : #'*GToolkit-Coder-UI' }
GtCategoryDefinition >> readers [
	^ { self categoryReader }
]
