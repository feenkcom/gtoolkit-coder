Extension { #name : #GtMethodCoder }

{ #category : #'*GToolkit-Coder-UI' }
GtMethodCoder >> asCoderUIModel [
	^ GtMethodCoderUIModel new coder: self
]

{ #category : #'*GToolkit-Coder-UI' }
GtMethodCoder >> breadcrumbActions [
	<return: #Array of: #GtSourceCoderBreadcrumbAction>

	^ Array streamContents: [ :aStream |
		(self compiledMethod ifNil: [ self classOrMetaClass ]) package
			ifNotNil: [ :aPackage |
				aStream nextPut: (GtSourceCoderBreadcrumbSpawnPackageAction new package: aPackage) ].
			
		aStream nextPut: (GtSourceCoderBreadcrumbSpawnClassAction new classOrMetaClass: self classOrMetaClass) ]
]

{ #category : #'*GToolkit-Coder-UI' }
GtMethodCoder >> browseFrom: anEditorElement [ 
	((GtCoder forMethod: self compiledMethod)
		openInPagerFrom: anEditorElement)
			maximized
]
