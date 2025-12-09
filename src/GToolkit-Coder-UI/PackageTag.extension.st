Extension { #name : #PackageTag }

{ #category : #'*GToolkit-Coder-UI' }
PackageTag >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtPackageTagCoderTool forPackageTag: self);
		addTool: super gtDefaultInspectorTool
]

{ #category : #'*GToolkit-Coder-UI' }
PackageTag >> gtSpawnCoder [
	^ GtPackageTagCoderTool forPackageTag: self
]
