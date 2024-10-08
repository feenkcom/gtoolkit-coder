"
I show a simple list of packages sorting alphabetically


"
Class {
	#name : #GtCoderNavigationPackagesTreeElement,
	#superclass : #BrSimpleTree,
	#traits : 'TGtCoderNavigationWithContextMenu',
	#classTraits : 'TGtCoderNavigationWithContextMenu classTrait',
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationPackagesTreeElement class >> fromPackages: aCollectionOfPackages [
	^ self new initializeWithPackages: aCollectionOfPackages
]

{ #category : #initialization }
GtCoderNavigationPackagesTreeElement >> buildRemovePackageLabelFor: aPackage [
	| labelText |
	labelText := 'Remove package <1s>' expandMacrosWith: aPackage name.
	^ BrLabel new
		margin: (BlInsets all: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #initialization }
GtCoderNavigationPackagesTreeElement >> buildRemoveTagLabelFor: aTag [
	| labelText |
	labelText := 'Remove package <1s>' expandMacrosWith: aTag name.
	^ BrLabel new
		margin: (BlInsets all: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #'private - enumeration' }
GtCoderNavigationPackagesTreeElement >> childrenForPackageOrTag: aPackageOrTag [
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
GtCoderNavigationPackagesTreeElement >> contextMenuItemsFor: aPackageOrTag [
	| items |
	items := {(self createLabel: 'New package / tag' description: '')
				-> [ :elem | self newPackage ]} asOrderedCollection.
	aPackageOrTag class == RPackage
		ifTrue: [ items
				addAll: {(self createLabel: 'Rename package' description: aPackageOrTag name)
							-> [ :elem | self renamePackage: aPackageOrTag inElement: elem ].
						(self createLabel: 'Remove package' description: aPackageOrTag name)
							-> [ :elem | self removePackage: aPackageOrTag inElement: elem ]} ]
		ifFalse: [ items
				addAll: {(self createLabel: 'Rename tag' description: aPackageOrTag name)
							-> [ :elem | self renameTag: aPackageOrTag inElement: elem ].
						(self createLabel: 'Remove tag' description: aPackageOrTag name)
							-> [ :elem | self removeTag: aPackageOrTag inElement: elem ]} ].

	^ items
]

{ #category : #initialization }
GtCoderNavigationPackagesTreeElement >> demotePackage: aPackageOrTag inElement: elem [ 
	self notYetImplemented
]

{ #category : #initialization }
GtCoderNavigationPackagesTreeElement >> initialize [
	super initialize.

	self rowStencil: BrGlamorousSimpleTreeSelectableRowElementStencilBuilder new.

	self
		nodeStencil: [
			| anItemElement |
			anItemElement := GtCoderNavigationPackagesTreeItemElement new.
			anItemElement
				hMatchParent;
				vFitContent;
				addAptitude: (BrGlamorousWithContextMenuAptitude
								content: [ GtCoderNavigationContextMenuContent new
										items: (self contextMenuItemsFor: anItemElement packageOrTag) ]) ];
		nodeDataBinder: [ :aPackageElement :aPackage | 
			aPackageElement packageOrTag: aPackage ]
]

{ #category : #'api - initialization' }
GtCoderNavigationPackagesTreeElement >> initializeWithPackages: aCollectionOfPackages [
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
GtCoderNavigationPackagesTreeElement >> isTag: tagA lessThan: tagB [
	tagA class = GtCoderPackageUncategorizedTag ifTrue: [ ^ true ].
	tagB class = GtCoderPackageUncategorizedTag ifTrue: [ ^ false ].
	^ tagA name < tagB name
	
]

{ #category : #initialization }
GtCoderNavigationPackagesTreeElement >> newPackage [
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
GtCoderNavigationPackagesTreeElement >> newTagFor: aPackage inElement: elem [
	self notYetImplemented
]

{ #category : #initialization }
GtCoderNavigationPackagesTreeElement >> promoteTag: aPackageOrTag inElement: elem [
	self notYetImplemented
]

{ #category : #initialization }
GtCoderNavigationPackagesTreeElement >> removePackage: aPackage inElement: elem [
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
GtCoderNavigationPackagesTreeElement >> removeTag: aTag inElement: elem [ 
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
GtCoderNavigationPackagesTreeElement >> renamePackage: aPackage inElement: elem [
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
GtCoderNavigationPackagesTreeElement >> renameTag: aPackageOrTag inElement: elem [
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

{ #category : #'api - selection' }
GtCoderNavigationPackagesTreeElement >> selectedIndice [
	"Return selected indice or zero"
	
	self selectedIndices
		ifNotEmpty: [ :theIndices |
			(theIndices first between: 1 and: self viewModel itemCount)
				ifTrue: [ ^ theIndices first ] ].
	^ 0
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTreeElement >> selectedPackage [
	<return: #RPackage or: nil>
	^ self selectedPackageNodeDo: #value
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTreeElement >> selectedPackageNodeDo: aBlock [
	self selectedNodeDo: [ :aNode | aNode depth = 0
		ifTrue: [ ^ aBlock cull: aNode ] ].
	^ nil
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTreeElement >> selectedPackageTag [
	<return: #RPackageTag or: nil>
	^ self selectedPackageTagNodeDo: #value
]

{ #category : #'api - selection' }
GtCoderNavigationPackagesTreeElement >> selectedPackageTagNodeDo: aBlock [
	self selectedNodeDo: [ :aNode | aNode depth = 1
		ifTrue: [ ^ aBlock cull: aNode ] ].
	^ nil
]
