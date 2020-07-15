Extension { #name : #ProtoObject }

{ #category : #'*GToolkit-Coder' }
ProtoObject >> gtBrowse [
	^ (GtCoder forObject: self) openInPager maximized
]

{ #category : #'*GToolkit-Coder' }
ProtoObject >> gtBrowseFrom: anElement [
	^ ((GtCoder forObject: self) 
		openInPagerFrom: anElement)
			maximized
]
