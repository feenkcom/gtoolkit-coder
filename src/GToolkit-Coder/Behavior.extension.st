Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseButtonFor: anAction [
	<gtClassAction>
	^ anAction button
		tooltip: 'Browse in another world tab';
		priority: 1;
		icon: BrGlamorousVectorIcons emphasizedBrowse;
		action: [ :aButton | self gtBrowseFromButton: aButton ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtBrowseFromButton: anElement [
	"Do we want to share the same coder model?"
	anElement phlow firstParentWithView navigationModel coderDo: [ :aCoder | 
		((GtCoder forCoder: aCoder asNewCoderModelWithSameSubject)
			openInPagerFrom: anElement)
				maximized ]
]

{ #category : #'*GToolkit-Coder' }
Behavior >> gtHierarchyButtonFor: anAction [
	<gtClassAction>
	^ anAction dropdown
		tooltip: 'Show Package and Class Hierarchies';
		icon: BrGlamorousIcons tree;
		priority: 3;
		content: [ :aButton | 
			| coder |
			coder := aButton phlow firstParentWithView.
			BlElement new
				size: 400 @ 400;
				addChild: ((GtCoderNavigationTabsStencil new
						navigationModel: coder navigationModel;
						asElement) background: Color white) ]
]
