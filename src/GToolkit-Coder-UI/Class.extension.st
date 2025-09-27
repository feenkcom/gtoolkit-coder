Extension { #name : #Class }

{ #category : #'*GToolkit-Coder-UI' }
Class >> asFilterModelItem [
	^ GtFilterModelClassItem new itemClass: self
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
		action: [ :aButton | aButton phlow spawnObject: self instanceSide ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexBrowseClassFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 1>
	^ BrMenuActionItem new
		icon: BrGlamorousVectorIcons browse
			label: 'Browse class'
			preview: self name;
		action: [ aGtCoderClassesTreeElement phlow spawnObject: self ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexBrowseClasses: someClasses referencesFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexSeveralSubjectsContextMenuItem: 2>
	^ BrMenuActionItem new
		icon: BrGlamorousVectorIcons empty
			label: 'Browse references'
			preview: ('{1} classes' format: { someClasses size });
		action: [ aGtCoderClassesTreeElement browseSeveralReferencesTo: someClasses ]
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
Class >> gtCoderSidebarIndexBrowseReferencesFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 2>
	^ BrMenuActionItem new
		icon: BrGlamorousVectorIcons empty
			label: 'Browse references'
			preview: self name;
		action: [ aGtCoderClassesTreeElement browseReferencesTo: self ]
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
Class >> gtCoderSidebarIndexCopyClassNameFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 9>
	^ BrMenuActionItem new
		icon: BrGlamorousVectorIcons clipboard
			label: 'Copy class name'
			preview: self name;
		action: [ Clipboard clipboardText: self name ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexExtractSuperclassFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 7>
	^ BrMenuSubmenuItem new
		icon: BrGlamorousVectorIcons empty
			label: 'Extract superclass'
			preview: self name;
		submenu: (aGtCoderClassesTreeElement
				convertToSiblingSubmenuFor: self
				siblings: #()
				title: 'Extract superclass');
		bePinSubmenuAction
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexLlmChatFor: anAction [
	<gtAction>
	| chat |
	GtLlmFeatures isEnabledInCoder ifFalse: [ ^ anAction noAction ].
	GtLlmConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction noAction ].

	^ anAction button
		priority: 20;
		target: GtCoderClassTarget;
		icon: BrGlamorousVectorIcons chat;
		label: ('Chat about this {1}' format: {self gtCoderTypeName});
		menuItemPreview: self name;
		menuItemGroup: BrMenuItemGroupConfiguration default;
		action: [ :aButton | 
			aButton phlow
				spawnObject: (chat ifNil: [ 
					chat := GtLlmClassAssistant new chatOn: self instanceSide ]) ]
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
			| aNavigationModel |
			aNavigationModel := aButton phlow firstParentCoderNavigationModel.
			BrVerticalPane new
				exact: 400 @ 300;
				addChild: ((GtCoderNavigationTabsStencil new
						pragmaName: #gtCoderDropdownNavigation;
						navigationModel: aNavigationModel;
						gtCreationInterface: aButton) background: Color white);
				addAptitude: (BrGlamorousPopoverPinnableAptitude new
						withResizers;
						withAllPinActions;
						menuModel: anExplicitMenu) ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexNewSubclassFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 3>
	^ BrMenuActionItem new
		icon: BrGlamorousVectorIcons add
			label: 'New subclass'
			preview: self name;
		action: [ aGtCoderClassesTreeElement newSubclassOf: self ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexRemoveClassFor: anAction [
	<gtAction>
	^ anAction dropdown 
		priority: 5;
		target: GtCoderClassTarget;
		id: #'coder--context-menu-remove-class';
		icon: BrGlamorousVectorIcons remove;
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
Class >> gtCoderSidebarIndexRemoveClassFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 5>
	^ BrMenuSubmenuItem new
		id: #'coder--context-menu-remove-class';
		icon: BrGlamorousVectorIcons remove
			label: 'Remove class'
			preview: self name;
		submenu: (aGtCoderClassesTreeElement removeClassSubmenuFor: self)
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexRemoveClasses: someClasses from: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexSeveralSubjectsContextMenuItem: 5>
	^ BrMenuSubmenuItem new
		icon: BrGlamorousVectorIcons remove
			label: 'Remove classes'
			preview: ('{1} classes' format: { someClasses size });
		submenu: (aGtCoderClassesTreeElement removeSeveralClassesSubmenuFor: someClasses)
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
					inputLabel: ('New {1} name:' format: { self gtCoderTypeName });
					initialText: self name;
					refactoringWithInput: [ :anInput | 
						GtRBRenameClassRefactoring 
							rename: self name 
							to: anInput ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithInputElement new 
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexRenameClassFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 4>
	^ BrMenuSubmenuItem new
		icon: BrGlamorousVectorIcons empty
			label: 'Rename class'
			preview: self name;
		submenu: (aGtCoderClassesTreeElement renameClassSubmenuFor: self);
		bePinSubmenuAction
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderTypeName [
	^ 'class'
]
