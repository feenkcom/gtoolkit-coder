"
I show a list of classes grouping them based on the inheritance hierarchy and sorting alphabetically


"
Class {
	#name : #GtCoderNavigationClassesHierarchyTreeElement,
	#superclass : #BrSimpleTree,
	#traits : 'TNavigationWithContextMenu',
	#classTraits : 'TNavigationWithContextMenu classTrait',
	#instVars : [
		'classesTree'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationClassesHierarchyTreeElement class >> fromClasses: aCollectionOfClasses [
	^ self new initializeWithClasses: aCollectionOfClasses
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> browseReferencesTo: aClass [
	self phlow spawnObject: (aClass gtReferences) 
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> buildRemoveClassLabelFor: aClass [
	| labelText |
	labelText := (aClass isReferenced
			ifTrue: [ '<1s> is referenced. Remove anyway?' ]
			ifFalse: [ aClass subclasses isEmpty
					ifTrue: [ 'Remove class <1s>' ]
					ifFalse: [ '<1s> has subclasses. Remove anyway?' ] ])
			expandMacrosWith: aClass name.
	^ BrLabel new
		margin: (BlInsets all: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> contextMenuItemsFor: aClass [
	^ {(self createLabel: 'Browse references' description: aClass name)
			-> [ :elem | self browseReferencesTo: aClass ].
		(self createLabel: 'New Subclass' description: aClass name)
			-> [ :elem | self newSubclassOf: aClass ].
		(self createLabel: 'Rename class' description: aClass name)
			-> [ :elem | self renameClass: aClass inElement: elem ].
		(self createLabel: 'Remove class' description: aClass name)
			-> [ :elem | self removeClass: aClass inElement: elem ]}
		, (aClass subclasses isEmpty
				ifTrue: [ #() ]
				ifFalse: [ {(self createLabel: 'Convert to sibling' description: aClass name)
							-> [ :elem | self convertToSibling: aClass inElement: elem ]} ])
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> convertToSibling: aClass inElement: elem [
	| refactoring label refactoringButton edit acceptButton |
	refactoringButton := GtRefactoringsWithInputPreviewElement new.
	refactoringButton cancelBlock: [  ].
	edit := BrHorizontalPane new.
	edit padding: (BlInsets all: 10).
	edit fitContent.
	edit
		addChild: (BrLabel new
				fitContent;
				aptitude: BrGlamorousLabelAptitude;
				text: 'Superclass:').
	label := BrEditableLabel new.
	label
		aptitude: (BrGlamorousEditableLabelAptitude new
				fontSize: 11.9;
				background: Color transparent);
		text: 'NewClass';
		focused: true;
		when: BrEditorCancelWish
			do: [ :wish | 
				refactoringButton previewButton fireEvent: BrDropdownHideWish new.
				refactoringButton removeFromParent ];
		when: BrEditorAcceptWish
			do: [ :aWish | 
				acceptButton removeFromParent.
				edit
					padding: (BlInsets
							top: 10
							bottom: 0
							left: 10
							right: 10).
				refactoring := RBChildrenToSiblingsRefactoring
						name: aWish text asString
						class: aClass
						subclasses: aClass subclasses.
				refactoringButton refactorings: [ {refactoring} ].
				label switchToLabel ];
		switchToEditor.
	label viewModel
		when: BrEditorModeChanged
		do: [ :event | 
			event mode isEditable
				ifTrue: [ edit padding: (BlInsets all: 10).
					refactoringButton refactorings: [ #() ].
					edit addChild: acceptButton ]
				ifFalse: [ refactoring
						ifNotNil: [ refactoringButton refactorings: [ {refactoring} ].
							acceptButton removeFromParent ] ] ].
	edit addChild: label.
	acceptButton := BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude new;
			id: GtRefactoringsPreviewAcceptId;
			icon: BrGlamorousVectorIcons accept;
			beSmallSize;
			requestFocus;
			label: 'Save';
			margin: (BlInsets
					top: 0
					left: 10
					bottom: 10
					right: 0);
			action: [ label acceptEdition ].
	edit addChild: acceptButton.
	refactoringButton editorElement: edit.
	refactoringButton enqueueTask: [ refactoringButton openPreview ] asBlTask.
	elem addChild: refactoringButton as: #refactoringButton
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> initialize [
	super initialize.

	self rowStencil: BrGlamorousSimpleTreeSelectableRowElementStencilBuilder new.

	self
		nodeStencil: [ BrHorizontalPane new
				hMatchParent;
				vFitContent ];
		nodeDataBinder: [ :aClassElement :aClassHierarchyTree :aTreeNode | 
			| label |
			aClassElement
				id: (GtCoderNavigationClassesHierarchyTreeElementId indexed: aTreeNode indexInTree);
				removeChildren;
				aptitude: BrGlamorousListItemAptitude new
						+ (BrGlamorousWithContextMenuAptitude
								content: [ GtCoderNavigationContextMenuContent new
										items: (self contextMenuItemsFor: aClassHierarchyTree rootClass) ]).
			label := BrLabel new
					matchParent;
					beSmallSize;
					aptitude: BrGlamorousLabelAptitude.
			aClassElement addChild: label.
			aClassHierarchyTree
				ifNil: [ label text: '' asRopedText ]
				ifNotNil: [ | aClass aText |
					aClass := aClassHierarchyTree rootClass.
					aText := aClass gtDisplayText asRopedText.
					(aClass isAbstract or: [ aClass hasAbstractMethods ])
						ifTrue: [ aText italic ].
					aClass isDeprecated
						ifTrue: [ aText append: ' (deprecated)' asRopedText italic ].
					label text: aText ] ].
	self
		when: BrSelectionDoubleClicked
		do: [ :evt | self initializeWithHierachyForClass: self selectedClass ]
]

{ #category : #'api - initialization' }
GtCoderNavigationClassesHierarchyTreeElement >> initializeWithClasses: aCollectionOfClasses [
	| newTree |
	newTree := (GtCoderClassesHierarchyTree fromClasses: aCollectionOfClasses)
			sortByClassName.
	newTree = classesTree ifTrue: [ ^ self ].
	classesTree := newTree.
	self
		items: classesTree subclassTrees
		lazy: [ :eachTree | eachTree subclassTrees ].
	self expandAll
]

{ #category : #'api - initialization' }
GtCoderNavigationClassesHierarchyTreeElement >> initializeWithHierachyForClass: aClass [
	classesTree := (GtCoderGrowingClassesHierarchyTree
		hierarchyForClass: aClass) sortByClassName.
	self
		items: classesTree subclassTrees
		lazy: [ :eachTree | eachTree subclassTrees ].
	self expandAll
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> newSubclassOf: aClass [
	| dropdown tabGroup |
	tabGroup := self
			withAllParentsDetect: [ :each | each class == BrTabGroup ]
			ifFound: #yourself
			ifNone: [ ^self ].
	dropdown := tabGroup childWithId: GtNavigationNewDropdownId.
	dropdown dispatchEvent: BrDropdownShowWish new.
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> removeClass: aClass inElement: elem [
	| change button |
	change := RBRemoveClassChange remove: aClass.
	button := GtPreviewChangeButton new
			icon: BrGlamorousVectorIcons remove;
			label: 'Remove';
			changeAction: [ change execute ];
			changeStencil: [ GtPharoRemoveClassPreviewStencil new
								classToRemove: aClass;
								anElement: self;
								create ].
	button
		when: GtRefactoringsAppliedEvent
		do: [ :anEvent | elem removeChild: anEvent currentTarget ].
	^ elem addChild: button as: #preview
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> renameClass: aClass inElement: elem [
	| refactoring edit childs |
	edit := BrEditableLabel new.
	childs := elem children.
	edit
		aptitude: (BrGlamorousEditableLabelAptitude new
				fontSize: 11.9;   "Force the font to match the label font"
				background: Color transparent);
		text: aClass name;
		when: BrEditorAcceptWish
			do: [ :aWish | 
				refactoring := RBRenameClassRefactoring
						rename: aClass name
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

{ #category : #'api - selection' }
GtCoderNavigationClassesHierarchyTreeElement >> selectedClass [
	<return: #Class or: nil>
	self selectedNodeDo: [ :aNode | ^ aNode value rootClass ].
	^ nil
]

{ #category : #'api - selection' }
GtCoderNavigationClassesHierarchyTreeElement >> selectedIndice [
	"Return selected indice or zero"
	
	self selectedIndices
		ifNotEmpty: [ :theIndices |
			(theIndices first between: 1 and: self viewModel itemCount)
				ifTrue: [ ^ theIndices first ] ].
	^ 0
]
