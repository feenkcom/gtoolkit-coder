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
	| aTool |

	aTool := GtObjectCoderTool forObject: self.

	^ BlSpace new
		withCommonSettings;
		inPager: aTool;
		withTitleAndIconOfTool: aTool;
		showFrom: anElement
]
