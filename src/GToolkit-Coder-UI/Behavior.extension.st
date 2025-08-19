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
	"Previous dropdown solution: Behavior>>#gtHierarchyButtonFor:"

	<gtClassAction>
	^ anAction toggle
		tooltip: 'Show Package and Class Hierarchies';
		icon: BrGlamorousIcons tree;
		id: GtCoderClassHierarchyButtonId;
		priority: 3;
		isActivated: [ :aToggle :aTargetElement | 
			aTargetElement isAttachedToSceneGraph
				ifTrue: [ | anEvent |
					anEvent := GtCoderSidebarVisibilityWish new.
					aTargetElement fireEvent: anEvent.
					anEvent isVisible ]
				ifFalse: [ BlTaskAction
						enqueueElement: aToggle
						action: [ | anEvent |
							anEvent := GtCoderSidebarVisibilityWish new.
							aToggle fireEvent: anEvent.
							aToggle activated: anEvent isVisible ].
					false ] ];
		activatedAction: [ :aButton | aButton fireEvent: GtCoderDisplayTopSidebarWish new ];
		deactivatedAction: [ :aButton | aButton fireEvent: GtCoderHideSidebarWish new ]
]

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtHierarchyButtonFor: anAction [
	"New implementation: Behavior>>#gtDisplayTopSidebarIndexToggleFor:"

	"<gtClassAction>"
	^ anAction dropdown
		tooltip: 'Show Package and Class Hierarchies';
		icon: BrGlamorousIcons tree;
		id: GtCoderClassHierarchyButtonId;
		priority: 3;
		preferredExtentFrom: GtPharoCoderHierarchyDropdownConfiguration;
		content: [ :aButton :aTargetElement :anExplicitMenu | 
			| aNavigationModel |
			aNavigationModel := aButton phlow firstParentCoderNavigationModel.
			BlElement new
				size: GtPharoCoderHierarchyDropdownConfiguration preferredExtent;
				addChild: ((GtCoderNavigationTabsStencil new
						pragmaName: #gtCoderDropdownNavigation;
						navigationModel: aNavigationModel;
						asElement) background: Color white);
				addAptitude: (BrGlamorousPopoverPinnableAptitude new
					withAllPinActions;
					menuModel: anExplicitMenu) ]
]
