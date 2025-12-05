Extension { #name : #Package }

{ #category : #'*GToolkit-Coder-UI' }
Package >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtPackageCoderTool forPackage: self);
		addTool: super gtDefaultInspectorTool
]

{ #category : #'*GToolkit-Coder-UI' }
Package >> gtSpawnCoder [
	^ GtPackageCoderTool forPackage: self
]
