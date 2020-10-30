Extension { #name : #GtClassDefinition }

{ #category : #'*GToolkit-Coder-UI' }
GtClassDefinition >> editors [
	<return: #Collection of: #GtCodeDefinitionViewer>
	
	^ { 
		self superclass superclassEditor.
		self category categoryEditor.
	 	self traits traitsEditor.
		self slots slotsEditor.
		self classVariables classVariablesEditor.
		self pools poolsEditor
	}
]

{ #category : #'*GToolkit-Coder-UI' }
GtClassDefinition >> readers [
	<return: #Collection of: #GtCodeDefinitionViewer>
	
	^ { 
		self superclass superclassReader.
		self category categoryReader.
	}
]
