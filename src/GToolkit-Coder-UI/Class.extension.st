Extension { #name : #Class }

{ #category : #'*GToolkit-Coder-UI' }
Class >> asFilterModelItem [
	^ GtFilterModelClassItem new itemClass: self
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexBehaviorDefinitionFor: anAction [
	<gtAction>
	^ anAction dropdown
		priority: 3;
		target: GtCoderClassTarget;
		icon: BrGlamorousVectorIcons edit;
		label: ('{1} definition' format: {self gtCoderTypeName asCamelCase});
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration modification;
		menuItemPinSubmenu;
		content: [ :aButton :aTargetElement :anExplicitMenu | 
			| aForm aFormElement |
			aForm := self isTrait
					ifTrue: [ GtTraitUpdateForm onTrait: self ]
					ifFalse: [ GtClassUpdateForm onClass: self ].
			aFormElement := aForm asElement.
			BrFrame new
				addChild: aFormElement;
				padding: (BlInsets all: GtRefactoringsConstants contextMenuPadding);
				hExact: 400;
				vFitContentLimited;
				background: aButton theme default contentBackground;
				addAptitude: (BrLayoutResizerAptitude new
						exactToMatchParent: aFormElement;
						matchParentToMatchParent: aFormElement;
						fitContentToFitContent: aFormElement;
						fitContentLimitedToFitContentLimited: aFormElement);
				addAptitude: (BrGlamorousPopoverPinnableAptitude new
						withLeftAndRightResizers;
						withAllPinActions;
						menuModel: anExplicitMenu) ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexBrowseClassesReferencesFor: anAction context: aPhlowContext [
	<gtAction>
	aPhlowContext coderSelectedClasses ifEmpty: [ ^ anAction noAction ].

	^ anAction button
		priority: 2;
		target: GtCoderClassesTarget;
		icon: BrGlamorousVectorIcons empty;
		label: 'Browse references';
		menuItemPreview: ('{1} classes' format: {aPhlowContext coderSelectedClasses size});
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | 
			| someClasses aFilter |
			someClasses := aPhlowContext coderSelectedClasses.
			aFilter := someClasses allButFirst
					inject: someClasses first gtReferences
					into: [ :aSumFilter :aClass | aSumFilter | aClass gtReferences ].

			aButton phlow spawnObject: aFilter ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexBrowseClassFor: anAction [
	<gtAction>
	^ anAction button
		priority: 1;
		target: GtCoderClassTarget;
		icon: BrGlamorousVectorIcons browse;
		label: ('Browse {1}' format: {self gtCoderTypeName});
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | aButton phlow spawnObject: self instanceSide ];
		primaryModifierAction: [ :aButton | self gtBrowseFrom: aButton ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexBrowseDefiningClassFor: anAction context: aPhlowContext [
	<gtAction>
	| aCompiledMethod |
	aCompiledMethod := aPhlowContext
			coderCompiledMethodIfPresent: [ :theCompiledMethod | aCompiledMethod := theCompiledMethod ]
			ifAbsent: [ nil ].
	aCompiledMethod ifNil: [ ^ anAction noAction ].
	aCompiledMethod methodClass = self ifTrue: [ ^ anAction noAction ].

	^ anAction button
		priority: 2;
		target: GtCoderClassTarget;
		icon: BrGlamorousVectorIcons browse;
		label: ('Browse defining {1}' format: {aCompiledMethod methodClass gtCoderTypeName});
		menuItemPreview: aCompiledMethod methodClass name;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | 
			 aButton phlow spawnTool: (GtMethodCoderTool compiledMethod: aCompiledMethod)  ];
		primaryModifierAction: [ :aButton | 
			 aCompiledMethod gtBrowseFrom: aButton ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexBrowseReferencesFor: anAction [
	<gtAction>
	^ anAction button 
		priority: 2;
		target: GtCoderClassTarget;
		icon: BrGlamorousVectorIcons empty;
		label: 'Browse references';
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | aButton phlow spawnObject: self instanceSide gtReferences ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexCopyClassNameFor: anAction [
	<gtAction>
	^ anAction button 
		priority: 9;
		target: GtCoderClassTarget;
		icon: BrGlamorousVectorIcons clipboard;
		label: ('Copy {1} name' format: {self gtCoderTypeName});
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration default;
		action: [ Clipboard clipboardText: self name ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexNewSubclassFor: anAction [
	<gtAction>
	^ anAction dropdown
		priority: 3;
		target: GtCoderClassTarget;
		icon: BrGlamorousVectorIcons add;
		label: (self isTrait ifFalse: [ 'New subclass' ] ifTrue: [ 'New trait user' ]);
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration modification;
		menuItemPinSubmenu;
		content: [ :aButton :aTargetElement :anExplicitMenu | 
			| aChild |
			aChild := aButton phlow
					firstParentCoderNavigationModelIfPresent: [ :aNavigationModel | 
						GtCoderNavigationTabsStencil new
							pragmaName: #gtCoderDropdownNavigation;
							navigationModel: aNavigationModel;
							gtCreationInterface: aButton ]
					ifAbsent: [ BrLabel new
							aptitude: BrGlamorousLabelAptitude new;
							text: 'Currently not available from lepiter';
							constraintsDo: [ :c | 
								c linear horizontal alignCenter.
								c linear vertical alignCenter ] ].

			BrVerticalPane new
				exact: 400 @ 300;
				addChild: aChild;
				background: aButton theme default contentBackground;
				addAptitude: (BrGlamorousPopoverPinnableAptitude new
						withLeftAndRightResizers;
						withAllPinActions;
						menuModel: anExplicitMenu) ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexRemoveClassesFor: anAction context: aPhlowContext [
	<gtAction>
	aPhlowContext coderSelectedClasses ifEmpty: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 5;
		target: GtCoderClassesTarget;
		icon: BrGlamorousVectorIcons empty;
		label: 'Remove classes';
		menuItemPreview: ('{1} classes' format: {aPhlowContext coderSelectedClasses size});
		menuItemGroup: BrMenuItemGroupConfiguration removal;
		content: [ :anActionElement :aTargetElement :anExplicitMenu | 
			| someClasses  |
			someClasses := aPhlowContext coderSelectedClasses.
			GtCoderRemoveClassesPreviewStencil new
				classesToRemove: someClasses;
				menuModel: anExplicitMenu;
				asElement ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexRemoveClassFor: anAction [
	<gtAction>
	^ anAction dropdown 
		priority: 5;
		target: GtCoderClassTarget;
		id: #'coder--context-menu-remove-class';
		icon: BrGlamorousVectorIcons bin;
		label: ('Remove {1}' format: {self gtCoderTypeName});
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration removal;
		menuItemPinSubmenu;
		content: [ :anActionElement :aTargetElement :anExplicitMenu | 
			GtCoderRemoveClassPreviewStencil new
				classToRemove: self instanceSide;
				menuModel: anExplicitMenu;
				asElement ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexRenameClassFor: anAction [
	<gtAction>
	^ anAction dropdown
		priority: 4;
		target: GtCoderClassTarget;
		icon: BrGlamorousVectorIcons empty;
		label: ('Rename {1}' format: {self gtCoderTypeName});
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration refactoring;
		content: [ :anActionElement :aTargetElement :anExplicitMenu | 
			| aViewModel |
			aViewModel := GtRefactoringsWithInputViewModel new
					refactoringTitle: ('Rename {1}' format: {self gtCoderTypeName});
					targetName: self name;
					inputLabel: ('New {1} name:' format: {self gtCoderTypeName});
					initialText: self name;
					refactoringWithInput: [ :anInput | GtRBRenameClassRefactoring rename: self name to: anInput ];
					afterAppliedBlock: [ BlTaskAction enqueueElement: aTargetElement action: [ anExplicitMenu hideAll ] ];
					menuModel: anExplicitMenu;
					anchorElement: aTargetElement.
			GtRefactoringsPreviewWithInputElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderTypeName [
	^ 'class'
]
