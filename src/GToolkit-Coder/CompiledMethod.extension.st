Extension { #name : #CompiledMethod }

{ #category : #'*GToolkit-Coder' }
CompiledMethod >> gtBrowseFrom: anElement [

	GtPager 
		openWrappedOn: (GtCoder forMethod: self) 
		title: 'Coder'
		from: anElement
]

{ #category : #'*GToolkit-Coder' }
CompiledMethod >> gtPackageScope [
	^ self package
]
