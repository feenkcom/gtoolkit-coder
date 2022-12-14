Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtBrowseButtonFor: anAction [
	<gtClassAction>
	^ anAction button
		tooltip: 'Browse in another world tab';
		priority: 1;
		id: GtCoderBrowseCoderButtonId;
		icon: BrGlamorousVectorIcons emphasizedBrowse;
		action: [ :aButton | self gtBrowseFromButton: aButton ]
]

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtHierarchyButtonFor: anAction [
	<gtClassAction>
	^ anAction dropdown
		tooltip: 'Show Package and Class Hierarchies';
		icon: BrGlamorousIcons tree;
		id: GtCoderClassHierarchyButtonId;
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
