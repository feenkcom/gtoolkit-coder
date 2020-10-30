Extension { #name : #ProtoObject }

{ #category : #'*GToolkit-Coder-Extensions' }
ProtoObject >> gtBrowse [
	^ (GtCoder forObject: self) openInPager maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
ProtoObject >> gtBrowseFrom: anElement [
	^ ((GtCoder forObject: self) 
		openInPagerFrom: anElement)
			maximized
]
