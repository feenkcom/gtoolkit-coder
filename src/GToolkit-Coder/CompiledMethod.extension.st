Extension { #name : #CompiledMethod }

{ #category : #'*GToolkit-Coder' }
CompiledMethod >> gtBrowseFrom: anElement [
	^ ((GtCoder forMethod: self) 
			openInPagerFrom: anElement)
			maximized
]

{ #category : #'*GToolkit-Coder' }
CompiledMethod >> gtPackageScope [
	^ self package
]
