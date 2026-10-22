Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtBrowse [
	^ BlSpace new
		withSceneDriller;
		inPager: [ GtClassCoderTool forClass: self ];
		title: self name;
		icon: BrGlamorousVectorIcons browse;
		show
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> gtBrowseFrom: anElement [
	| aTool |

	aTool := self gtDefaultInspectorTool.

	^ BlSpace new
		withCommonSettings;
		inPager: aTool;
		withTitleAndIconOfTool: aTool;
		showFrom: anElement
]
