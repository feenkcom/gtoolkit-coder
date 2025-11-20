Extension { #name : #RPackage }

{ #category : #'*GToolkit-Coder-UI' }
RPackage >> gtSpawnCoder [
	^ GtPackageCoderTool forPackage: self
]
