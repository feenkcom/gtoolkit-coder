Extension { #name : #GtMetaclassDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtMetaclassDefinition >> editors [
	<return: #Collection of: #GtCodeDefinitionViewer>
	
	^ { 
		self category categoryEditor.
		self slots slotsEditor.
	}
]

{ #category : #'*GToolkit-Coder-UI' }
GtMetaclassDefinition >> readers [
	<return: #Collection of: #GtCodeDefinitionViewer>
	
	^ { 
		self category categoryReader.
	}
]
