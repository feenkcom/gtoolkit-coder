Extension { #name : #ProtoObject }

{ #category : #'*GToolkit-Coder-Extensions' }
ProtoObject >> gtBrowse [
	^ BlSpace new
		withSceneDriller;
		inPager: [ GtObjectCoderTool forObject: self ];
		icon: BrGlamorousVectorIcons browse;
		show
]

{ #category : #'*GToolkit-Coder-Extensions' }
ProtoObject >> gtBrowseFrom: anElement [
	^ BlSpace new
		withCommonSettings;
		inPager: [ GtObjectCoderTool forObject: self ];
		icon: BrGlamorousVectorIcons browse;
		showFrom: anElement
]
