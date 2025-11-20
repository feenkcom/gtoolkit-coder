Extension { #name : #PackageTag }

{ #category : #'*GToolkit-Coder-UI' }
PackageTag >> gtSpawnCoder [
	^ GtPackageTagCoderTool forPackageTag: self
]
