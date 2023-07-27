Extension { #name : #ProtoObject }

{ #category : #'*GToolkit-Coder-Extensions' }
ProtoObject >> gtBrowse [
	^ (GtCoderElement forObject: self) openInPager maximized
]

{ #category : #'*GToolkit-Coder-Extensions' }
ProtoObject >> gtBrowseFrom: anElement [
	^ ((GtCoderElement forObject: self) asElement openInPagerFrom: anElement) maximized
]
