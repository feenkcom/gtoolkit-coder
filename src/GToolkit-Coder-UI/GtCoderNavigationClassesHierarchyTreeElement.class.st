"
I show a list of classes grouping them based on the inheritance hierarchy and sorting alphabetically


"
Class {
	#name : #GtCoderNavigationClassesHierarchyTreeElement,
	#superclass : #BrSimpleTree,
	#traits : 'TGtCoderNavigationWithContextMenu',
	#classTraits : 'TGtCoderNavigationWithContextMenu classTrait',
	#instVars : [
		'classesTree'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationClassesHierarchyTreeElement class >> fromClasses: aCollectionOfClasses [
	^ self new initializeWithClasses: aCollectionOfClasses
]

{ #category : #'private - context menu' }
GtCoderNavigationClassesHierarchyTreeElement >> addPreviewButtonFor: refactoring to: elem cancelBlock: aBlock [
	| button |
	elem removeChildNamed: #preview.
	button := GtRefactoringsPreviewButton new.
	button vMatchParent.
	button refactorings: [ {refactoring} ].
	button cancelBlock: aBlock.
	button
		padding: (BlInsets
				top: 1
				right: 4
				bottom: 0
				left: 4).
	button beMiniSize.
	button
		when: GtRefactoringsAppliedEvent
		do: [ :anEvent | elem removeChild: anEvent currentTarget ].
	^ elem addChild: button as: #preview
]

{ #category : #'private - context menu' }
GtCoderNavigationClassesHierarchyTreeElement >> addPreviewButtonFor: refactoring to: elem cancelSelector: cancelSelector [
	| button |
	elem removeChildNamed: #preview.
	button := GtRefactoringsPreviewButton new.
	button vMatchParent.
	button refactorings: [ {refactoring} ].
	button cancelBlock: [ self perform: cancelSelector  ].
	button
		padding: (BlInsets
				top: 1
				right: 4
				bottom: 0
				left: 4).
	button beMiniSize.
	button
		when: GtRefactoringsAppliedEvent
		do: [ :anEvent | elem removeChild: anEvent currentTarget ].
	^ elem addChild: button as: #preview
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

{ #category : #'private - context menu' }
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

{ #category : #'private - drag and drop' }
GtCoderNavigationClassesHierarchyTreeElement >> createClassDropHandler [
	^ BlDropHandler new
		acceptDomainObjectsSuchThat: [ :anObject | anObject isCompiledMethod ];
		whenDroppedDo: [ :anItemsDroppedEvent | self onDropCompiledMethodsOnClass: anItemsDroppedEvent  ];
		whenDragEnteredDo: [ :anItemsDraggedOverEvent | 
			anItemsDraggedOverEvent currentTarget
				effect: (BlOverlayAboveEffect new paint: (Color gray alpha: 0.2)) ];
		whenDragLeftDo: [ :anItemsLeftEvent | anItemsLeftEvent currentTarget effect: BlNullEffect new ]
]

{ #category : #'private - context menu' }
GtCoderNavigationClassesHierarchyTreeElement >> createLabel: aString description: description [
	^ aString asRopedText glamorousRegularFont
		, ((' ' , description) asRopedText
				glamorousCodeFont;
				foreground: Color gray;
				glamorousCodeTinySize)
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> createNodeElement [
	| aLabelAptitude |

	aLabelAptitude := BrGlamorousLabelAptitude new.
	aLabelAptitude add: BrGlamorousListItemAptitude.
	aLabelAptitude
		add: (BrGlamorousWithContextMenuAptitude
				content: [ :aWidget | 
					GtCoderNavigationContextMenuContent new
						items: (self contextMenuItemsFor: (aWidget userData at: #'coder-class')) ]).

	^ BrLabel new
		hMatchParent;
		vFitContent;
		beSmallSize;
		aptitude: aLabelAptitude;
		addEventHandler: self createClassDropHandler
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> initialize [
	super initialize.

	self rowStencil: BrGlamorousSimpleTreeSelectableRowElementStencilBuilder new.

	self
		nodeStencil: [ self createNodeElement ];
		nodeDataBinder: [ :aClassElement :aClassHierarchyTree :aTreeNode | 
			aClassElement
				id: (GtCoderNavigationClassesHierarchyTreeElementId indexed: aTreeNode indexInTree).

			aClassElement userData at: #'coder-class' put: aClassHierarchyTree rootClass.

			aClassHierarchyTree
				ifNil: [ aClassElement text: '' asRopedText ]
				ifNotNil: [ | aClass aText |
					aClass := aClassHierarchyTree rootClass.
					aText := aClass gtDisplayText asRopedText.
					(aClass isAbstract or: [ aClass hasAbstractMethods ])
						ifTrue: [ aText italic ].
					aClass isDeprecated
						ifTrue: [ aText append: ' (deprecated)' asRopedText italic ].
					aClassElement text: aText ] ].
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

{ #category : #'private - context menu' }
GtCoderNavigationClassesHierarchyTreeElement >> newSubclassOf: aClass [
	| dropdown tabGroup |
	tabGroup := self
			withAllParentsDetect: [ :each | each class == BrTabGroup ]
			ifFound: #yourself
			ifNone: [ ^self ].
	dropdown := tabGroup childWithId: GtNavigationNewDropdownId.
	dropdown dispatchEvent: BrDropdownShowWish new.
]

{ #category : #'private - drag and drop' }
GtCoderNavigationClassesHierarchyTreeElement >> onDropCompiledMethodsOnClass: anItemsDroppedEvent [
	| aClass aModel compositeChange|
	
	aClass := anItemsDroppedEvent currentTarget userData at: #'coder-class'.
	
	aModel := RBNamespace new.
	
	anItemsDroppedEvent items do: [ :eachDragItem |
		| eachCompiledMethod aTargetClass |
		
		eachCompiledMethod := eachDragItem domainObject.
		
		aTargetClass := eachCompiledMethod isClassSide
			ifTrue: [ aClass classSide ]
			ifFalse: [ aClass instanceSide ].
		
		eachCompiledMethod methodClass = aTargetClass
			ifFalse: [
				eachDragItem shouldCopy
					ifFalse: [
						aModel
							removeMethod: eachCompiledMethod selector
							from: eachCompiledMethod methodClass ].

				aModel
					compile: eachCompiledMethod sourceCode
					in: aTargetClass
					classified: eachCompiledMethod protocol ] ].

	compositeChange := aModel changes.
	compositeChange execute
]

{ #category : #'private - context menu' }
GtCoderNavigationClassesHierarchyTreeElement >> removeClass: aClass inElement: elem [
	| change button |
	change := RBRemoveClassChange remove: aClass.
	button := GtPreviewChangeButton new
			icon: BrGlamorousVectorIcons remove;
			label: 'Remove';
			changeAction: [ change gtExecuteWithUndo ];
			changeStencil: [ GtPharoRemoveClassPreviewStencil new
								classToRemove: aClass;
								anElement: self;
								create ].
	button
		when: GtRefactoringsAppliedEvent
		do: [ :anEvent | elem removeChild: anEvent currentTarget ].
	^ elem addChild: button as: #preview
]

{ #category : #'private - context menu' }
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
				refactoring := GtRBRenameClassRefactoring
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
