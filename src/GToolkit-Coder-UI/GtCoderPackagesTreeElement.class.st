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
		margin: (BlInsets all: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> buildRemoveTagLabelFor: aTag [
	| labelText |
	labelText := 'Remove package <1s>' expandMacrosWith: aTag name.
	^ BrLabel new
		margin: (BlInsets all: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #'private - enumeration' }
GtCoderPackagesTreeElement >> childrenForPackageOrTag: aPackageOrTag [
	| theTags anExtension |
	(aPackageOrTag isKindOf: RPackage) ifFalse: [ ^ #() ].
	theTags := aPackageOrTag classTags asOrderedCollection.
	theTags withIndexDo: [ :eachTag :eachIndex | eachTag name = aPackageOrTag name ifTrue: [ 
		theTags at: eachIndex put: (GtCoderPackageUncategorizedTag forPackageTag: eachTag) ] ].
	theTags sort: [ :tagA :tagB | self isTag: tagA lessThan: tagB ].

	anExtension := GtCoderPackageExtensionTag forPackage: aPackageOrTag.
	anExtension hasExtendedClasses ifTrue: [ 
		theTags addLast: anExtension ].
	"Do not return an only tag of the same name as the package"
	(theTags size = 1 and: [ 
		theTags anyOne class = GtCoderPackageUncategorizedTag ]) ifTrue: [ ^ #() ].
	
	^ theTags
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> contextMenuItemsFor: aPackageOrTag [
	| items |
	items := {(self createLabel: 'New package / tag' description: '')
				-> [ :elem | self newPackage ]} asOrderedCollection.
	aPackageOrTag class == RPackage
		ifTrue: [ items
				addAll: {(self createLabel: 'Rename package' description: aPackageOrTag name)
							-> [ :elem | self requestRenamePackage: aPackageOrTag ].
						(self createLabel: 'Remove package' description: aPackageOrTag name)
							-> [ :elem | self removePackage: aPackageOrTag inElement: elem ]} ]
		ifFalse: [ items
				addAll: {(self createLabel: 'Rename tag' description: aPackageOrTag name)
							-> [ :elem | self requestRenamePackage: aPackageOrTag ].
						(self createLabel: 'Remove tag' description: aPackageOrTag name)
							-> [ :elem | self removeTag: aPackageOrTag inElement: elem ]} ].

	^ items
]

{ #category : #'as yet unclassified' }
GtCoderPackagesTreeElement >> createRenamePackageForm: aPackageOrTag [
	^ GtCoderPackagesTreeRenameEditor new
		itemToRename: aPackageOrTag;
		renameAction: [ :anItemToRename :aNewName |
			(anItemToRename isKindOf: RPackage)
				ifTrue: [
					(GtRBRenamePackageRefactoring
						from: anItemToRename name
						to: aNewName)
							execute ].
			(anItemToRename isKindOf: RPackageTag)
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
						addAptitude: (BrGlamorousWithExplicitContextMenuAptitude
								itemsWithAnchorActions: [ (self contextMenuItemsFor: anItemElement packageOrTag) ]) ] ];
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

{ #category : #'as yet unclassified' }
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
GtCoderPackagesTreeElement >> removePackage: aPackage inElement: elem [
	| change button |
	change := RBRemovePackageChange removePackageNamed: aPackage name.
	button := GtPreviewChangeButton new
			icon: BrGlamorousVectorIcons remove;
			label: 'Remove';
			changeAction: [ change execute ];
			changeStencil: [ self buildRemovePackageLabelFor: aPackage ].
	button
		when: GtRefactoringsAppliedEvent
		do: [ :anEvent | elem removeChild: anEvent currentTarget ].
	^ elem addChild: button as: #preview
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> removeTag: aTag inElement: elem [ 
	| change button |
	change := GtRBRemovePackageTagChange packageName: aTag package name tagName: aTag name.
	button := GtPreviewChangeButton new
			icon: BrGlamorousVectorIcons remove;
			label: 'Remove';
			changeAction: [ change execute ];
			changeStencil: [ self buildRemoveTagLabelFor: aTag ].
	button
		when: GtRefactoringsAppliedEvent
		do: [ :anEvent | elem removeChild: anEvent currentTarget ].
	^ elem addChild: button as: #preview
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> renamePackage: aPackage inElement: elem [
	| refactoring edit childs |
	childs := elem children.
	edit := BrEditableLabel new.
	edit
		aptitude: (BrGlamorousEditableLabelAptitude new
				fontSize: 11.9;   "Force the font to match the label font"
				background: Color transparent);
		text: aPackage name;
		when: BrEditorAcceptWish
			do: [ :aWish | 
				refactoring := GtRBRenamePackageRefactoring
						from: aPackage name
						to: aWish text asString.
				edit switchToLabel.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelBlock: [ elem removeChildren.
						elem addChildren: childs ] ];
		switchToEditor.
	edit requestFocus.
	elem removeChildren.
	elem addChild: edit
]

{ #category : #initialization }
GtCoderPackagesTreeElement >> renameTag: aPackageOrTag inElement: elem [
	| refactoring edit childs |
	childs := elem children.
	edit := BrEditableLabel new.
	edit
		aptitude: (BrGlamorousEditableLabelAptitude new
				fontSize: 11.9;
				background: Color transparent);
		text: aPackageOrTag name;
		when: BrEditorAcceptWish
			do: [ :aWish | 
				refactoring := GtRBRenamePackageTagRefactoring
						packageName: aPackageOrTag package name
						from: aPackageOrTag name
						to: aWish text asString.
				edit switchToLabel.
				self
					addPreviewButtonFor: refactoring
					to: elem
					cancelBlock: [ elem removeChildren.
						elem addChildren: childs ] ];
		switchToEditor.	"Force the font to match the label font"
	edit requestFocus.
	elem removeChildren.
	elem addChild: edit
]

{ #category : #'as yet unclassified' }
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
	<return: #RPackage or: nil>
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
	<return: #RPackageTag or: nil>
	^ self selectedPackageTagNodeDo: #value
]

{ #category : #'api - selection' }
GtCoderPackagesTreeElement >> selectedPackageTagNodeDo: aBlock [
	self selectedNodeDo: [ :aNode | aNode depth = 1
		ifTrue: [ ^ aBlock cull: aNode ] ].
	^ nil
]
