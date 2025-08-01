Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseFromButton: anElement [
	"Do we want to share the same coder model?"

	anElement phlow firstParentCoderNavigationModel
		coderDo: [ :aCoder | 
			BlSpace new
				withSceneDriller;
				inPager: [ GtReadyCoderTool coder: aCoder asNewCoderModelWithSameSubject ];
				title: self printString;
				icon: BrGlamorousVectorIcons browse;
				showFrom: anElement ]
]
