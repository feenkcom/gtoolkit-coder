Extension { #name : #Class }

{ #category : #'*GToolkit-Coder-UI' }
Class >> asFilterModelItem [
	^ GtFilterModelClassItem new itemClass: self
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
Class >> gtCoderSidebarIndexBrowseReferencesFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 2>
	^ BrMenuActionItem new
		icon: BrGlamorousVectorIcons empty
			label: 'Browse references'
			preview: self name;
		action: [ aGtCoderClassesTreeElement browseReferencesTo: self ]
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
		submenu: (aGtCoderClassesTreeElement convertToSiblingSubmenuFor: self siblings: #());
		bePinSubmenuAction
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
Class >> gtCoderSidebarIndexRenameClassFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 4>
	^ BrMenuSubmenuItem new
		icon: BrGlamorousVectorIcons empty
			label: 'Rename class'
			preview: self name;
		submenu: (aGtCoderClassesTreeElement renameClassSubmenuFor: self)
]
