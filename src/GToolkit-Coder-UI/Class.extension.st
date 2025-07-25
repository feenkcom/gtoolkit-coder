Extension { #name : #Class }

{ #category : #'*GToolkit-Coder-UI' }
Class >> asFilterModelItem [
	^ GtFilterModelClassItem new itemClass: self
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexBrowseClassFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 1>
	^ BrMenuActionItem new
		label: 'Browse class' preview: self name;
		action: [ aGtCoderClassesTreeElement phlow spawnObject: self ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexBrowseReferencesFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 2>
	^ BrMenuActionItem new
		label: 'Browse references' preview: self name;
		action: [ aGtCoderClassesTreeElement browseReferencesTo: self ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexExtractSuperclassFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 7>
	self subclasses notEmpty ifFalse: [ ^ nil ].

	^ BrMenuSubmenuItem new
		label: 'Extract superclass' preview: self name;
		submenu: (aGtCoderClassesTreeElement convertToSiblingSubmenuFor: self siblings: #())
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexGitFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 7>
	^ BrMenuActionItem new
		id: GtCoderGitButtonId;
		icon: BrGlamorousVectorIcons branching
			label: 'Browse git repository'
			preview: self;
		action: [ :aButton | 
			| coder repository |
			repository := self repository.
			repository
				ifNil: [ aButton phlow
						spawnTool: (GtPhlowExplicitTool new
								stencil: [ GtGitAddToRepositoryElement new package: coder navigationModel selectedPackage ]) ]
				ifNotNil: [ aButton phlow
						spawnTool: (GtGitPhlowTool new repository: repository) ] ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexNewSubclassFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 3>
	^ BrMenuActionItem new
		label: 'New subclass' preview: self name;
		action: [ aGtCoderClassesTreeElement newSubclassOf: self ]
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexRemoveClassFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 5>
	^ BrMenuSubmenuItem new
		label: 'Remove class' preview: self name;
		submenu: (aGtCoderClassesTreeElement removeClassSubmenuFor: self)
]

{ #category : #'*GToolkit-Coder-UI' }
Class >> gtCoderSidebarIndexRenameClassFrom: aGtCoderClassesTreeElement [
	<gtCoderSidebarIndexOneSubjectContextMenuItem: 4>
	^ BrMenuSubmenuItem new
		label: 'Rename class' preview: self name;
		submenu: (aGtCoderClassesTreeElement renameClassSubmenuFor: self)
]
