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
	^ BlSpace new
		withSceneDriller;
		inPager: [ GtClassCoderTool forClass: self ];
		title: self name;
		icon: BrGlamorousVectorIcons browse;
		showFrom: anElement
]

{ #category : #'*GToolkit-Coder-Extensions' }
Behavior >> methodsCoderFromContext: aPhlowContext [
	<return: #GtPharoMethodsCoderViewModel>

	^ (GtClassMethodsCoder forClass: self) asCoderViewModel
]
