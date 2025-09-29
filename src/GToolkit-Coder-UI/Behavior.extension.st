Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtDisplayTopSidebarIndexToggleFor: anAction [
	"Previous dropdown solution: Behavior>>#gtHierarchyButtonFor:"

	<gtClassAction>
	^ anAction toggle
		tooltip: 'Show Package and Class Hierarchies';
		icon: BrGlamorousVectorIcons tree;
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
					GtCoderSettings defaultDetailState = GtPhlowToolDetailState detailed ] ];
		activatedAction: [ :aButton | aButton fireEvent: GtCoderDisplayTopSidebarWish new ];
		deactivatedAction: [ :aButton | aButton fireEvent: GtCoderHideSidebarWish new ]
]

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtHierarchyButtonFor: anAction [
	"New implementation: Behavior>>#gtDisplayTopSidebarIndexToggleFor:"

	"<gtClassAction>"
	^ anAction dropdown
		tooltip: 'Show Package and Class Hierarchies';
		icon: BrGlamorousVectorIcons tree;
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
