Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtBrowseButtonFor: anAction [
	<gtClassAction>
	^ anAction button
		priority: 1;
		tooltip: 'Browse class';
		icon: BrGlamorousVectorIcons emphasizedBrowse;
		action: [ :aButton | 
			aButton phlow firstParentCoderNavigationModel
				coderDo: [ :oldCoder | 
					aButton phlow
						spawnTool: (GtReadyCoderTool coder: oldCoder asNewCoderModelWithSameSubject) ] ];
		primaryModifierAction: [ :aButton | self gtBrowseFromButton: aButton ]
			mouseCursor: BlCopyCursor new
]

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtDisplayTopSidebarIndexToggleFor: anAction [
	<gtClassAction>
	^ anAction toggle
		tooltip: 'Show Package and Class Hierarchies';
		icon: BrGlamorousIcons tree;
		id: GtCoderClassHierarchyButtonId;
		priority: 3;
		isActivated: [ :aTargetElement | 
			| anEvent |
			anEvent := GtCoderSidebarVisibilityWish new.
			aTargetElement fireEvent: anEvent.
			anEvent isVisible ];
		activatedAction: [ :aButton | aButton fireEvent: GtCoderDisplayTopSidebarWish new ];
		deactivatedAction: [ :aButton | aButton fireEvent: GtCoderHideSidebarWish new ]
]
