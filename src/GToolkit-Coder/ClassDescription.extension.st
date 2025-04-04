Extension { #name : #ClassDescription }

{ #category : #'*GToolkit-Coder' }
ClassDescription >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtClassCoderTool forClass: self);
		addTool: super gtDefaultInspectorTool
]

{ #category : #'*GToolkit-Coder' }
ClassDescription >> gtPackageScope [
	^ self package
]
