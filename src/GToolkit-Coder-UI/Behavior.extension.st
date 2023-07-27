Extension { #name : #Behavior }

{ #category : #'*GToolkit-Coder-UI' }
Behavior >> gtBrowseButtonFor: anAction [
	<gtClassAction>
	^ anAction explicit
		priority: 1;
		stencil: [ | button |
			button := BrButton new
					id: GtCoderBrowseCoderButtonId;
					aptitude: BrGlamorousButtonWithIconAptitude;
					label: 'Browse class';
					icon: BrGlamorousVectorIcons emphasizedBrowse;
					action: [ :aButton :aModel :anEvent | 
						anEvent modifiers isPrimaryModifier
							ifTrue: [ self gtBrowseFromButton: aButton ]
							ifFalse: [ aButton phlow
									spawnTool: (GtPhlowValuableTool new
											name: self gtDisplayString;
											valuable: [ | aCoder |
												aButton phlow firstParentCoderNavigationModel
													coderDo: [ :oldCoder | aCoder := GtCoderElement forCoder: oldCoder asNewCoderModelWithSameSubject ].
												aCoder ]) ] ].
			button viewModel
				when: BlClickEvent
				do: [ :anEvent | 
					anEvent modifiers isPrimaryModifier
						ifTrue: [ button viewModel clickEvent: anEvent ] ].
			button viewModel
				when: BlMouseEnterEvent
				do: [ :anEvent | 
					anEvent consumed: true.
					anEvent modifiers isPrimaryModifier
						ifTrue: [ anEvent target mouseCursor: BlCopyCursor new ]
						ifFalse: [ anEvent target mouseCursor: nil ].
					anEvent target requestFocus ].
			button ]
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
			| aNavigationModel |
			aNavigationModel := aButton phlow firstParentCoderNavigationModel.
			BlElement new
				size: 400 @ 400;
				addChild: ((GtCoderNavigationTabsStencil new
						navigationModel: aNavigationModel;
						asElement) background: Color white) ]
]
