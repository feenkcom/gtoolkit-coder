Extension { #name : #Object }

{ #category : #'*GToolkit-Coder-Extensions' }
Object >> gtBrowse [
	^ BlSpace new
		withSceneDriller;
		inPager: [ GtObjectCoderTool forObject: self ];
		title: self gtDisplayString;
		icon: BrGlamorousVectorIcons browse;
		show
]

{ #category : #'*GToolkit-Coder-Extensions' }
Object >> gtBrowseFrom: anElement [
	^ BlSpace new
		withSceneDriller;
		inPager: [ GtObjectCoderTool forObject: self ];
		title: self gtDisplayString;
		icon: BrGlamorousVectorIcons browse;
		showFrom: anElement
]
