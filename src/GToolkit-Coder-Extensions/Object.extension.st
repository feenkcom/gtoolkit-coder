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
	| aTool |

	aTool := GtObjectCoderTool forObject: self.

	^ BlSpace new
		withSceneDriller;
		inPager: aTool;
		withTitleAndIconOfTool: aTool;
		showFrom: anElement
]
