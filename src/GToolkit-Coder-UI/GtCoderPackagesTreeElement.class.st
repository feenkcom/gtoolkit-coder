"
I show a simple list of packages sorting alphabetically


"
Class {
	#name : #GtCoderPackagesTreeElement,
	#superclass : #BrSimpleTree,
	#traits : 'TGtCoderNavigationWithContextMenu',
	#classTraits : 'TGtCoderNavigationWithContextMenu classTrait',
	#instVars : [
		'packageToRename',
		'renamingEditor'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #'instance creation' }
GtCoderPackagesTreeElement class >> fromPackages: aCollectionOfPackages [
	^ self new initializeWithPackages: aCollectionOfPackages
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> buildRemovePackageLabelFor: aPackage [
	| labelText |
	labelText := 'Remove package <1s>' expandMacrosWith: aPackage name.
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> buildRemoveTagLabelFor: aTag [
	| labelText |
	labelText := 'Remove package tag <1s>' expandMacrosWith: aTag name.
	^ BrLabel new
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #'private - enumeration' }
GtCoderPackagesTreeElement >> childrenForPackageOrTag: aPackageOrTag [
	| theTags anExtension |
	(aPackageOrTag isPharoPackageModel) ifFalse: [ ^ #() ].
	
	theTags := aPackageOrTag tags asOrderedCollection.
	theTags withIndexDo: [ :eachTag :eachIndex | 
		eachTag isRoot ifTrue: [ 
			theTags 
				at: eachIndex 
				put: (GtCoderPackageUncategorizedTag forPackageTag: eachTag) ] ].
	theTags sort: [ :tagA :tagB | self isTag: tagA lessThan: tagB ].

	anExtension := GtCoderPackageExtensionTag forPackage: aPackageOrTag.
	anExtension hasExtendedClasses ifTrue: [ 
		theTags addLast: anExtension ].
		
	"Do not return an only root tag that contains all classes"
	(theTags size = 1 and: [ 
		theTags anyOne class = GtCoderPackageUncategorizedTag ]) ifTrue: [ ^ #() ].
	
	^ theTags
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> contextMenuFor: aPackageOrTag [
	| menu |
	menu := BrMenuItems new.
	menu
		addItemLabel: (self createLabel: 'New package / tag' description: '')
		action: [ self newPackage ].
	aPackageOrTag isPharoPackageModel
		ifTrue: [ menu
				addItem: (BrMenuSubmenuItem new
						label: (self createLabel: 'Rename package' description: aPackageOrTag name);
						submenu: (self renamePackageSubmenuFor: aPackageOrTag);
						bePinSubmenuAction).
			menu
				addItem: (BrMenuSubmenuItem new
						label: (self createLabel: 'Remove package' description: aPackageOrTag name);
						submenu: (self removePackageSubmenuFor: aPackageOrTag)) ]
		ifFalse: [ menu
				addItem: (BrMenuSubmenuItem new
						label: (self createLabel: 'Rename tag' description: aPackageOrTag name);
						submenu: (self renamePackageTagSubmenuFor: aPackageOrTag);
						bePinSubmenuAction).
			menu
				addItem: (BrMenuSubmenuItem new
						label: (self createLabel: 'Remove tag' description: aPackageOrTag name);
						submenu: (self removePackageTagSubmenuFor: aPackageOrTag)) ].

	^ menu
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> createPackageOrTagDropHandler [
	^ BlDropHandler new
		acceptItemsSuchThat: [ :aDragItem :aGtCoderPackagesTreeItemElement | 
			aDragItem domainObject isClassOrTrait
				and: [ (aGtCoderPackagesTreeItemElement packageOrTag
						isKindOf: GtCoderPackageExtensionTag) not
						and: [ | aPackageOrTag |
							aPackageOrTag := aDragItem domainObject package
									tagOf: aDragItem domainObject.
							aPackageOrTag isRoot
								ifTrue: [ aPackageOrTag := GtCoderPackageUncategorizedTag forPackageTag: aPackageOrTag ].

							aPackageOrTag isRoot
								ifFalse: [ aGtCoderPackagesTreeItemElement packageOrTag ~= aPackageOrTag ]
								ifTrue: [ aGtCoderPackagesTreeItemElement packageOrTag ~= aPackageOrTag
										and: [ aPackageOrTag package ~= aGtCoderPackagesTreeItemElement packageOrTag ] ] ] ] ];
		whenDroppedDo: [ :anItemsDroppedEvent | self onDropClassesOnPackageOrTag: anItemsDroppedEvent ];
		whenDragEnteredDo: [ :anItemsDraggedOverEvent | 
			anItemsDraggedOverEvent mayAcceptItems
				ifTrue: [ anItemsDraggedOverEvent currentTarget
						effect: (BlOverlayAboveEffect new paint: (Color gray alpha: 0.2)) ] ];
		whenDragLeftDo: [ :anItemsLeftEvent | anItemsLeftEvent currentTarget effect: BlNullEffect new ]
]

{ #category : #'private - context menu' }
GtCoderPackagesTreeElement >> createRenamePackageForm: aPackageOrTag [
	^ GtCoderPackagesTreeRenameEditor new
		itemToRename: aPackageOrTag;
		renameAction: [ :anItemToRename :aNewName |
			(anItemToRename isPharoPackageModel)
				ifTrue: [
					(GtRBRenamePackageRefactoring
						from: anItemToRename name
						to: aNewName)
							execute ].
			(anItemToRename isPharoPackageTagModel)
				ifTrue: [
					(GtRBRenamePackageTagRefactoring
						packageName: anItemToRename package name
						from: anItemToRename name
						to: aNewName)
							execute ] ];
		endRenameAction: [ self privateEndRenamePackage ]
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> demotePackage: aPackageOrTag inElement: elem [ 
	self notYetImplemented
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> initialize [
	super initialize.

	self rowStencil: BrGlamorousSimpleTreeSelectableRowElementStencilBuilder new.

	self
		nodeType: [ :aTypeFactory :aTreeNode | aTreeNode value = packageToRename ifTrue: [ #rename ] ifFalse: [ #display ] ];
		nodeStencil: [ :anItemType | 
			anItemType = #rename
				ifTrue: [ BrFrame new
						id: #'coder--package-rename';
						hMatchParent;
						vFitContent ]
				ifFalse: [ | anItemElement |
					anItemElement := GtCoderPackagesTreeItemElement new.
					anItemElement
						hMatchParent;
						vFitContent;
						addEventHandler: self createPackageOrTagDropHandler;
						addAptitude: (BrGlamorousWithExplicitContextMenuAptitude
								menu: [ self contextMenuFor: anItemElement packageOrTag ]) ] ];
		nodeDataBinder: [ :aPackageElement :aPackage | 
			aPackageElement id asSymbol = #'coder--package-rename'
				ifTrue: [ aPackageElement removeChildren.
					renamingEditor
						ifNil: [ renamingEditor := self createRenamePackageForm: aPackage ].
					aPackageElement addChild: renamingEditor ]
				ifFalse: [ aPackageElement packageOrTag: aPackage ] ]
]

{ #category : #'api - initialization' }
GtCoderPackagesTreeElement >> initializeWithPackages: aCollectionOfPackages [
	| theSortedPackages |
	theSortedPackages := aCollectionOfPackages asArray
		sorted:
			[ :packageA :packageB | packageA name asLowercase < packageB name asLowercase ].
	self
		items: theSortedPackages
		lazy:
			[ :eachPackageOrTag | self childrenForPackageOrTag: eachPackageOrTag ]
]

{ #category : #'private - testing' }
GtCoderPackagesTreeElement >> isTag: tagA lessThan: tagB [
	tagA class = GtCoderPackageUncategorizedTag ifTrue: [ ^ true ].
	tagB class = GtCoderPackageUncategorizedTag ifTrue: [ ^ false ].
	^ tagA name < tagB name
	
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> newPackage [
	| dropdown tabGroup |
	tabGroup := self
			withAllParentsDetect: [ :each | each class == BrTabGroup ]
			ifFound: #yourself
			ifNone: [ ^self ].
	dropdown := tabGroup childWithId: GtNavigationNewDropdownId.
	dropdown dispatchEvent: BrDropdownShowWish new.
	dropdown dispatchEvent: (GtNavigationDropDownCreateWish showTab: GtPackageCreationForm).
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> newTagFor: aPackage inElement: elem [
	self notYetImplemented
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> onDropClassesOnPackageOrTag: anItemsDroppedEvent [
	| aPackageOrTag aModel compositeChange someRefactorings aPromise |
	aPackageOrTag := anItemsDroppedEvent currentTarget packageOrTag.
	aModel := Smalltalk createRbNamespace
			onEnvironment: GtRBPushDownMethodRefactoring new defaultEnvironment.

	someRefactorings := anItemsDroppedEvent items
			collect: [ :eachDragItem | 
				| eachClass |
				eachClass := eachDragItem domainObject.

				GtRBMoveClassToPackageRefactoring
					model: aModel
					move: eachClass name
					to: aPackageOrTag categoryName ].

	someRefactorings do: #primitiveExecute.
	compositeChange := aModel changes.

	"We use 1 threshold to keep coders with the same selected package."
	aPromise := compositeChange gtExecuteWithNotificationThreshold: 1.
	self enqueueTask: (BlPromiseTask new promise: aPromise).
]

{ #category : #'private - context menu' }
GtCoderPackagesTreeElement >> privateEndRenamePackage [
	"Removes package editing UI"

	packageToRename := nil.
	renamingEditor := nil.
	self viewModel notifyChildrenChanged
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> promoteTag: aPackageOrTag inElement: elem [
	self notYetImplemented
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> removePackageSubmenuFor: aPackage [
	| submenu |
	submenu := BrMenuExplicit new.
	^ submenu
		stencil: [ | element change button |
			element := BrVerticalPane new fitContent.
			element
				addChild: ((self buildRemovePackageLabelFor: aPackage)
						margin: (BlInsets
								top: 10
								bottom: 0
								left: 10
								right: 10)).
			element
				addChild: (BrAsyncWidget new
						fitContent;
						stencil: [ | pane definedClasses extendedClasses |
							pane := BrVerticalPane new.
							pane fitContent.
							definedClasses := aPackage definedClassNames size.
							extendedClasses := aPackage extendedClassNames size.
							definedClasses > 0
								ifTrue: [ pane
										addChild: (BrLabel new
												margin: (BlInsets left: 10 right: 10);
												aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
												text: (definedClasses printString , ' defined class'
														, (definedClasses > 1 ifTrue: [ 'es' ] ifFalse: [ '' ]))
														asRopedText) ].
							extendedClasses > 0
								ifTrue: [ pane
										addChild: (BrLabel new
												margin: (BlInsets left: 10 right: 10);
												aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
												text: (extendedClasses printString , ' extended class'
														, (extendedClasses > 1 ifTrue: [ 'es' ] ifFalse: [ '' ]))
														asRopedText) ].
							pane ]).
			change := RBRemovePackageChange removePackageNamed: aPackage name.
			button := BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					beSmallSize;
					margin: (BlInsets
							top: 10
							bottom: 10
							left: 10
							right: 10);
					icon: BrGlamorousVectorIcons remove;
					label: 'Remove';
					action: [ submenu hideAll.
						change execute ].
			element addChild: button as: #removeButton.
			element ]
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> removePackageTagSubmenuFor: aPackageTag [
	| submenu |
	submenu := BrMenuExplicit new.
	^ submenu
		stencil: [ | element change button |
			element := BrVerticalPane new fitContent.
			element
				addChild: ((self buildRemoveTagLabelFor: aPackageTag)
						margin: (BlInsets
								top: 10
								bottom: 0
								left: 10
								right: 10)).
			change := GtRBRemovePackageTagChange
					packageName: aPackageTag package name
					tagName: aPackageTag name.
			button := BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					beSmallSize;
					margin: (BlInsets
							top: 10
							bottom: 10
							left: 10
							right: 10);
					icon: BrGlamorousVectorIcons remove;
					label: 'Remove';
					action: [ submenu hideAll.
						change execute ].
			element addChild: button as: #removeButton.
			element ]
]

{ #category : #'private - context menu' }
GtCoderPackagesTreeElement >> renamePackageSubmenuFor: aPackage [
	^ BrMenuExplicit new
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			anExplicitMenu id: #'coder--context-menu-rename-package-form'.

			aViewModel := GtRefactoringsWithInputViewModel new
					refactoringTitle: 'Rename package';
					targetName: aPackage name;
					inputLabel: 'New package name:';
					initialText: aPackage name;
					refactoringWithInput: [ :anInput | 
						GtRBRenamePackageRefactoring from: aPackage name to: anInput ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithInputElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]

{ #category : #'private - context menu' }
GtCoderPackagesTreeElement >> renamePackageTagSubmenuFor: aPackageTag [
	^ BrMenuExplicit new
		stencil: [ :anExplicitMenu | 
			| aViewModel |
			anExplicitMenu id: #'coder--context-menu-rename-package-tag-form'.

			aViewModel := GtRefactoringsWithInputViewModel new
					refactoringTitle: 'Rename package tag';
					targetName: aPackageTag name;
					inputLabel: 'New package tag name:';
					initialText: aPackageTag name;
					refactoringWithInput: [ :anInput | 
						GtRBRenamePackageTagRefactoring
							packageName: aPackageTag packageName
							from: aPackageTag name
							to: anInput ];
					afterAppliedBlock: [ anExplicitMenu hideAll ];
					menuModel: anExplicitMenu;
					anchorElement: self.
			GtRefactoringsPreviewWithInputElement new
				refactoringsViewModel: aViewModel;
				beContextMenuElement;
				bePinnable: anExplicitMenu ]
]

{ #category : #'private - context menu' }
GtCoderPackagesTreeElement >> requestRenamePackage: aPackageOrTag [
	"An entrance point to the rename package action.
	Presents a UI to rename a given package"

	packageToRename := aPackageOrTag.
	renamingEditor := nil.
	self viewModel notifyChildrenChanged
]

{ #category : #'api - selection' }
GtCoderPackagesTreeElement >> selectedIndice [
	"Return selected indice or zero"
	
	self selectedIndices
		ifNotEmpty: [ :theIndices |
			(theIndices first between: 1 and: self viewModel itemCount)
				ifTrue: [ ^ theIndices first ] ].
	^ 0
]

{ #category : #'api - selection' }
GtCoderPackagesTreeElement >> selectedPackage [
	<return: #Package or: nil>
	^ self selectedPackageNodeDo: #value
]

{ #category : #'api - selection' }
GtCoderPackagesTreeElement >> selectedPackageNodeDo: aBlock [
	self selectedNodeDo: [ :aNode | aNode depth = 0
		ifTrue: [ ^ aBlock cull: aNode ] ].
	^ nil
]

{ #category : #'api - selection' }
GtCoderPackagesTreeElement >> selectedPackageTag [
	<return: #PackageTag or: nil>
	^ self selectedPackageTagNodeDo: #value
]

{ #category : #'api - selection' }
GtCoderPackagesTreeElement >> selectedPackageTagNodeDo: aBlock [
	self selectedNodeDo: [ :aNode | aNode depth = 1
		ifTrue: [ ^ aBlock cull: aNode ] ].
	^ nil
]
