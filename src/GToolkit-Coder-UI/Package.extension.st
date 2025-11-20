Extension { #name : #Package }

{ #category : #'*GToolkit-Coder-UI' }
Package >> gtSpawnCoder [
	^ GtPackageCoderTool forPackage: self
]
