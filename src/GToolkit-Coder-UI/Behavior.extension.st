Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtBrowseButtonFor: anAction [
	<gtClassAction>
	
	^ anAction button
		priority: 1;
		tooltip: 'Browse class';
		icon: BrGlamorousVectorIcons emphasizedBrowse;
		action: [ :aButton | 
			aButton phlow
				spawnTool: (GtPhlowExplicitTool new
					name: self gtDisplayString;
					stencil: [ 
						| aCoder |
						aButton phlow firstParentCoderNavigationModel
							coderDo: [ :oldCoder | 
								aCoder := GtCoderElement forCoder: oldCoder asNewCoderModelWithSameSubject ].
							aCoder ]) ];
		primaryModifierAction: [ :aButton | self gtBrowseFromButton: aButton ]
			mouseCursor: BlCopyCursor new.
]

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtHierarchyButtonFor: anAction [
	<gtClassAction>
	^ anAction dropdown
		tooltip: 'Show Package and Class Hierarchies';
		icon: BrGlamorousIcons tree;
		id: GtCoderClassHierarchyButtonId;
		priority: 3;
		preferredExtentFrom: GtPharoCoderHierarchyDropdownConfiguration;
		content: [ :aButton | 
			| aNavigationModel |
			aNavigationModel := aButton phlow firstParentCoderNavigationModel.
			BlElement new
				size: GtPharoCoderHierarchyDropdownConfiguration preferredExtent;
				addChild: ((GtCoderNavigationTabsStencil new
						pragmaName: #gtCoderDropdownNavigation;
						navigationModel: aNavigationModel;
						asElement) background: Color white) ]
]
