Extension { #name : #PackageTag }

{ #category : #'*GToolkit-Coder-Extensions' }
PackageTag >> gtBrowseFrom: anElement [
	^ BlSpace new
		withCommonSettings;
		inPager: [ self gtDefaultInspectorTool ];
		title: self name;
		icon: BrGlamorousVectorIcons browse;
		showFrom: anElement
]
