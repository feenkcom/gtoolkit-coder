Extension { #name : #CompiledMethod }

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtBrowse [
	^ (GtCoder forMethod: self) 
			openInPager
			maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
CompiledMethod >> gtBrowseFrom: anElement [
	^ ((GtCoder forMethod: self) 
			openInPagerFrom: anElement)
			maximized
]
