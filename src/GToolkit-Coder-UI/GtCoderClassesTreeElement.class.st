"
#Classes tree element

I show a list of classes grouping them based on the inheritance hierarchy and sorting alphabetically.
It is a building block of the navigation UI in Coder.

{{gtExample:GtCoderNavigationClassesHierarchyListElementExamples>>#fromCollectionClasses|previewShow=#gtLiveFor:|noCode|previewHeight=180}}
"
Class {
	#name : #GtCoderClassesTreeElement,
	#superclass : #BrSimpleTree,
	#traits : 'TGtCoderNavigationWithContextMenu',
	#classTraits : 'TGtCoderNavigationWithContextMenu classTrait',
	#instVars : [
		'classesTree'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #'instance creation' }
GtCoderClassesTreeElement class >> fromClasses: aCollectionOfClasses [
	^ self new initializeWithClasses: aCollectionOfClasses
]

{ #category : #'private - context menu' }
GtCoderClassesTreeElement >> addPreviewButtonFor: refactoring to: elem cancelSelector: cancelSelector [
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
GtCoderClassesTreeElement >> bind: aClassHierarchyTree element: aClassElement index: anIndexInTree [
	aClassElement
		id: (GtCoderNavigationClassesTreeElementId indexed: anIndexInTree).
		
	aClassElement classHierarchyTree: aClassHierarchyTree
]

{ #category : #initialization }
GtCoderClassesTreeElement >> browseReferencesTo: aClass [
	self phlow spawnObject: (aClass gtReferences) 
]

{ #category : #initialization }
GtCoderClassesTreeElement >> buildRemoveClassLabelFor: aClass [
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

{ #category : #'as yet unclassified' }
GtCoderClassesTreeElement >> containsClass: aClass [
	"Return true if the classes tree contains a given class, false otherwise"
	^ classesTree containsClass: aClass
]

{ #category : #initialization }
GtCoderClassesTreeElement >> contextMenuFor: aClass in: anElement [
	| menu |
	menu := BrMenuItems new.
	menu
		addItemLabel: (self createLabel: 'Browse references' description: aClass name)
		action: [ self browseReferencesTo: aClass ].
	menu
		addItemLabel: (self createLabel: 'New Subclass' description: aClass name)
		action: [ self newSubclassOf: aClass ].
	menu
		addItemLabel: (self createLabel: 'Rename class' description: aClass name)
		action: [ self renameClass: aClass inElement: anElement ].
	menu
		addItem: (BrMenuSubmenuItem new
				label: (self createLabel: 'Remove class' description: aClass name);
				submenu: (BrMenuExplicit new stencil: [ self removeClassSubmenuFor: aClass ])).
	aClass subclasses notEmpty
		ifTrue: [ menu
				addItemLabel: (self createLabel: 'Convert to sibling' description: aClass name)
				action: [ self convertToSibling: aClass inElement: anElement ] ].
	^ menu
]

{ #category : #'private - context menu' }
GtCoderClassesTreeElement >> convertToSibling: aClass inElement: elem [
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
GtCoderClassesTreeElement >> createClassDropHandler [
	^ BlDropHandler new
		acceptDomainObjectsSuchThat: [ :anObject | anObject isCompiledMethod ];
		whenDroppedDo: [ :anItemsDroppedEvent | self onDropCompiledMethodsOnClass: anItemsDroppedEvent  ];
		whenDragEnteredDo: [ :anItemsDraggedOverEvent | 
			anItemsDraggedOverEvent currentTarget
				effect: (BlOverlayAboveEffect new paint: (Color gray alpha: 0.2)) ];
		whenDragLeftDo: [ :anItemsLeftEvent | anItemsLeftEvent currentTarget effect: BlNullEffect new ]
]

{ #category : #'private - context menu' }
GtCoderClassesTreeElement >> createLabel: aString description: description [
	^ aString asRopedText glamorousRegularFont
		, ((' ' , description) asRopedText
				glamorousCodeFont;
				foreground: Color gray;
				glamorousCodeTinySize)
]

{ #category : #initialization }
GtCoderClassesTreeElement >> createNodeElement [
	^ GtCoderClassesTreeItemElement new
		addEventHandler: self createClassDropHandler;
		in: [ :aWidget | 
			aWidget
				addAptitude: (BrGlamorousWithExplicitContextMenuAptitude
						menu: [ self contextMenuFor: aWidget theClass in: aWidget ]) ];
		yourself
]

{ #category : #initialization }
GtCoderClassesTreeElement >> initialize [
	super initialize.

	self rowStencil: BrGlamorousSimpleTreeSelectableRowElementStencilBuilder new.

	self
		nodeStencil: [ self createNodeElement ];
		nodeDataBinder: [ :aClassElement :aClassHierarchyTree :aTreeNode | 
			self
				bind: aClassHierarchyTree
				element: aClassElement
				index: aTreeNode indexInTree ].
	self
		when: BrSelectionDoubleClicked
		do: [ :evt | self initializeWithHierachyForClass: self selectedClass ]
]

{ #category : #'api - initialization' }
GtCoderClassesTreeElement >> initializeWithClasses: aCollectionOfClasses [
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
GtCoderClassesTreeElement >> initializeWithHierachyForClass: aClass [
	classesTree := (GtCoderGrowingClassesHierarchyTree hierarchyForClass: aClass)
			sortByClassName.
	self
		items: classesTree subclassTrees
		lazy: [ :eachTree | eachTree subclassTrees ].
	self expandAll.

	self viewModel root
		allChildrenNodesBreadthFirstDo: [ :treeNode | 
			treeNode ensureChildrenNodes.
			aClass = treeNode value rootClass
				ifTrue: [ self selectOne: treeNode indexInTree.
					self scrollToIndex: treeNode indexInTree.
					^ self ] ]
]

{ #category : #'private - context menu' }
GtCoderClassesTreeElement >> newSubclassOf: aClass [
	| dropdown tabGroup |
	tabGroup := self
			withAllParentsDetect: [ :each | each class == BrTabGroup ]
			ifFound: #yourself
			ifNone: [ ^self ].
	dropdown := tabGroup childWithId: GtNavigationNewDropdownId.
	dropdown dispatchEvent: BrDropdownShowWish new.
]

{ #category : #'private - drag and drop' }
GtCoderClassesTreeElement >> onDropCompiledMethodsOnClass: anItemsDroppedEvent [
	| aClass aModel compositeChange|
	
	aClass := anItemsDroppedEvent currentTarget theClass.
	
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

{ #category : #initialization }
GtCoderClassesTreeElement >> removeClassSubmenuFor: aClass [
	| element references subclasses change button |
	element := BrVerticalPane new fitContent.
	references := (GtPharoIndex current globalVariableReferencesTo: aClass binding)
			size.
	subclasses := aClass allSubclasses size.
	element
		addChild: ((self buildRemoveClassLabelFor: aClass)
				margin: (BlInsets
						top: 10
						bottom: 0
						left: 10
						right: 10)).
	references > 0
		ifTrue: [ element
				addChild: (BrLabel new
						margin: (BlInsets left: 10 right: 10);
						aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
						text: (references printString , ' reference'
								, (references > 1 ifTrue: [ 's' ] ifFalse: [ '' ])) asRopedText) ].
	subclasses > 0
		ifTrue: [ element
				addChild: (BrLabel new
						margin: (BlInsets left: 10 right: 10);
						aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
						text: (subclasses printString , ' subclass'
								, (subclasses > 1 ifTrue: [ 'es' ] ifFalse: [ '' ])) asRopedText) ].
	change := RBRemoveClassChange remove: aClass.
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
			action: [ change execute ].
	element addChild: button as: #removeButton.
	^ element
]

{ #category : #'private - context menu' }
GtCoderClassesTreeElement >> renameClass: aClass inElement: elem [
	| refactoring edit childs restoreBlock |
	edit := BrEditableLabel new.
	childs := elem children.
	restoreBlock := [ (edit parent notNil
			and: [ edit parent children identityIncludes: edit ])
			ifTrue: [ elem removeChildren.
				elem addChildren: childs ] ].
	edit
		aptitude: (BrGlamorousEditableLabelAptitude new
				fontSize: 11.9;	"Force the font to match the label font"
				background: Color transparent);
		text: aClass name;
		when: BrEditorCancelWish do: [ :wish | restoreBlock value ];
		when: BrEditorAcceptWish
			do: [ :aWish | 
				refactoring := GtRBRenameClassRefactoring
						rename: aClass name
						to: aWish text asString.
				edit switchToLabel.
				self
					addPreviewButtonFor: refactoring
					to: elem
					appliedBlock: restoreBlock
					cancelBlock: restoreBlock ];
		switchToEditor.
	edit requestFocus.
	elem removeChildren.
	elem addChild: edit as: #renameClassEditor
]

{ #category : #'api - selection' }
GtCoderClassesTreeElement >> selectedClass [
	<return: #Class or: nil>
	self selectedNodeDo: [ :aNode | ^ aNode value rootClass ].
	^ nil
]

{ #category : #'api - selection' }
GtCoderClassesTreeElement >> selectedIndice [
	"Return selected indice or zero"
	
	self selectedIndices
		ifNotEmpty: [ :theIndices |
			(theIndices first between: 1 and: self viewModel itemCount)
				ifTrue: [ ^ theIndices first ] ].
	^ 0
]
