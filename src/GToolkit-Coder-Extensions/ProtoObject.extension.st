Extension { #name : #ProtoObject }

{ #category : #'*GToolkit-Coder-Extensions' }
ProtoObject >> gtBrowse [
	^ (GtCoder forObject: self) openInPager maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
ProtoObject >> gtBrowseFrom: anElement [
	^ ((GtPhlowCoderView new coder: (GtCoder forObject: self)) asElement
		openInPagerFrom: anElement) maximized
]
