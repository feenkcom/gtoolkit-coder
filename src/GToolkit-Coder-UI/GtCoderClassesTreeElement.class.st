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
GtCoderClassesTreeElement >> browseSeveralReferencesTo: someClasses [
	| aFilter |
	aFilter := someClasses allButFirst
			inject: someClasses first gtReferences
			into: [ :aSumFilter :aClass | aSumFilter | aClass gtReferences ].

	self phlow spawnObject: aFilter
]

{ #category : #initialization }
GtCoderClassesTreeElement >> buildRemoveClassLabelFor: aClass [
	| labelText |
	labelText := 'Remove class ' , aClass name.
	^ BrLabel new
		margin: (BlInsets all: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #initialization }
GtCoderClassesTreeElement >> buildRemoveSeveralClassesLabelFor: someClasses [
	| labelText |
	labelText := 'Remove {1} classes' format: { someClasses size }.
	^ BrLabel new
		margin: (BlInsets all: 10);
		aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
		text: labelText asRopedText
]

{ #category : #testing }
GtCoderClassesTreeElement >> containsClass: aClass [
	"Return true if the classes tree contains a given class, false otherwise"
	^ classesTree containsClass: aClass
]

{ #category : #initialization }
GtCoderClassesTreeElement >> contextMenuFor: aClass [
	| someClasses |
	someClasses := self selectedItems collect: #rootClass.

	^ (someClasses size < 2 or: [ (someClasses includes: aClass) not ])
		ifTrue: [ self contextMenuForOneItem: aClass ]
		ifFalse: [ self contextMenuForSeveralItems: someClasses ]
]

{ #category : #initialization }
GtCoderClassesTreeElement >> contextMenuForOneItem: aClass [
	^ BrMenuItemsPragmaBuilder new
		object: aClass;
		upToSuperclass: Behavior;
		pragma: #gtCoderSidebarIndexOneSubjectContextMenuItem:;
		methodArguments: { self };
		sortByFirstPragmaArgument;
		build
]

{ #category : #initialization }
GtCoderClassesTreeElement >> contextMenuForSeveralItems: someClasses [
	^ BrMenuItemsPragmaBuilder new
		object: Class;
		upToSuperclass: Behavior;
		pragma: #gtCoderSidebarIndexSeveralSubjectsContextMenuItem:;
		methodArguments: {someClasses. self};
		sortByFirstPragmaArgument;
		build
]

{ #category : #'private - drag and drop' }
GtCoderClassesTreeElement >> createClassDragHandler [
	^ BlDragHandler new
		liftItem: [ :aGtCoderClassesTreeItemElement | 
			| someClasses currentClass |
			currentClass := aGtCoderClassesTreeItemElement theClass.
			someClasses := self selectedItems collect: #rootClass.
			(someClasses size > 1 and: [ someClasses includes: currentClass ])
				ifTrue: [ someClasses
						collect: [ :each | 
							BlDragItem new
								sourceElement: aGtCoderClassesTreeItemElement;
								domainObject: each;
								stencil: [ :aDragItem | self createSeveralDraggedClassesItem: someClasses ] ] ]
				ifFalse: [ BlDragItem new
						sourceElement: aGtCoderClassesTreeItemElement;
						domainObject: currentClass;
						stencil: [ :aDragItem | self createDraggedMethodItem: aDragItem ] ] ]
]

{ #category : #'private - drag and drop' }
GtCoderClassesTreeElement >> createClassDropHandler [
	^ BlDropHandler new
		acceptItemsSuchThat: [ :aDragItem :aGtCoderClassesTreeItemElement | 
			aDragItem domainObject isCompiledMethod
				and: [ aGtCoderClassesTreeItemElement theClass ~= aDragItem domainObject methodClass ] ];
		whenDroppedDo: [ :anItemsDroppedEvent | self onDropCompiledMethodsOnClass: anItemsDroppedEvent  ];
		whenDragEnteredDo: [ :anItemsDraggedOverEvent | 
			anItemsDraggedOverEvent mayAcceptItems
				ifTrue: [ anItemsDraggedOverEvent currentTarget
					effect: (BlOverlayAboveEffect new paint: (Color gray alpha: 0.2)) ] ];
		whenDragLeftDo: [ :anItemsLeftEvent | anItemsLeftEvent currentTarget effect: BlNullEffect new ]
]

{ #category : #'private - drag and drop' }
GtCoderClassesTreeElement >> createDraggedMethodItem: aDragItem [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new padding: (BlInsets all: 5)) + BrShadowAptitude;
		beSmallSize;
		opacity: 0.85;
		margin: (BlInsets all: 5);
		background: Color white;
		beFocusable;
		requestFocus;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 5);
		fitContent;
		text: aDragItem domainObject printString
]

{ #category : #initialization }
GtCoderClassesTreeElement >> createExceptionItemFor: anException andPragma: eachPragma [
	| frozenException |
	frozenException := (GtSystemUtility freeze: anException)
			tag: eachPragma;
			yourself.
	^ anException
		return: (BrMenuActionItem new
				label: 'Error' preview: frozenException messageText;
				action: [ :anElement :aButtonModel :anEvent | anElement phlow spawnObject: frozenException ])
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
		addEventHandler: self createClassDragHandler;
		in: [ :aWidget | 
			aWidget
				addAptitude: (BrGlamorousWithExplicitContextMenuAptitude
						menu: [ self contextMenuFor: aWidget theClass ]) ];
		yourself
]

{ #category : #'private - drag and drop' }
GtCoderClassesTreeElement >> createSeveralDraggedClassesItem: someClassHierarchyTrees [
	^ BrLabel new
		aptitude: (BrGlamorousLabelAptitude new padding: (BlInsets all: 5)) + BrShadowAptitude;
		beSmallSize;
		opacity: 0.85;
		margin: (BlInsets all: 5);
		background: Color white;
		beFocusable;
		requestFocus;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 5);
		fitContent;
		text: ('{1} classes' format: {someClassHierarchyTrees size})
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
	| submenu |
	submenu := BrMenuExplicit new.
	^ submenu
		stencil: [ | element change button |
			element := BrVerticalPane new fitContent.
			element
				addChild: ((self buildRemoveClassLabelFor: aClass)
						margin: (BlInsets
								top: 10
								bottom: 0
								left: 10
								right: 10)).
			element
				addChild: (BrAsyncWidget new
						fitContent;
						stencil: [ | pane references subclasses |
							references := (GtPharoIndex current
									globalVariableReferencesTo: aClass binding) size.
							subclasses := aClass allSubclasses size.
							pane := BrVerticalPane new.
							pane fitContent.
							references > 0
								ifTrue: [ pane
										addChild: (BrLabel new
												margin: (BlInsets left: 10 right: 10);
												aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
												text: (references printString , ' reference'
														, (references > 1 ifTrue: [ 's' ] ifFalse: [ '' ])) asRopedText) ].
							subclasses > 0
								ifTrue: [ pane
										addChild: (BrLabel new
												margin: (BlInsets left: 10 right: 10);
												aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
												text: (subclasses printString , ' subclass'
														, (subclasses > 1 ifTrue: [ 'es' ] ifFalse: [ '' ])) asRopedText) ].
							pane ]).
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
					action: [ submenu hideAll.
						change execute ].
			element addChild: button as: #removeButton.
			element ]
]

{ #category : #initialization }
GtCoderClassesTreeElement >> removeSeveralClassesSubmenuFor: someClasses [
	| submenu |
	submenu := BrMenuExplicit new.
	^ submenu
		stencil: [ | element change button |
			element := BrVerticalPane new fitContent.
			element
				addChild: ((self buildRemoveSeveralClassesLabelFor: someClasses)
						margin: (BlInsets
								top: 10
								bottom: 0
								left: 10
								right: 10)).
			element
				addChild: (BrAsyncWidget new
						fitContent;
						stencil: [ | pane references subclasses |
							references := someClasses sumNumbers: [ :eachClass | (GtPharoIndex current
									globalVariableReferencesTo: eachClass binding) size ].
							subclasses := someClasses sumNumbers: [ :eachClass | (eachClass allSubclasses difference: someClasses) size ].
							pane := BrVerticalPane new.
							pane fitContent.
							references > 0
								ifTrue: [ pane
										addChild: (BrLabel new
												margin: (BlInsets left: 10 right: 10);
												aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
												text: (references printString , ' reference'
														, (references > 1 ifTrue: [ 's' ] ifFalse: [ '' ])) asRopedText) ].
							subclasses > 0
								ifTrue: [ pane
										addChild: (BrLabel new
												margin: (BlInsets left: 10 right: 10);
												aptitude: BrGlamorousLabelAptitude new glamorousRegularFont thin;
												text: (subclasses printString , ' subclass'
														, (subclasses > 1 ifTrue: [ 'es' ] ifFalse: [ '' ])) asRopedText) ].
							pane ]).
			change := RBCompositeRefactoryChange new
				name: ('Remove {1} classes' format: { someClasses size });
				changes: (someClasses collect: [ :eachClass | RBRemoveClassChange remove: eachClass ]).
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
GtCoderClassesTreeElement >> renameClassSubmenuFor: aClass [
	| submenu |
	submenu := BrMenuExplicit new.
	submenu
		stencil: [ GtRefactoringsWithInputPreviewElement
				elementForRefactoring: [ :each | GtRBRenameClassRefactoring rename: aClass name to: each ]
				labeled: 'Rename class: '
				initialValue: aClass name
				from: self
				beforeApplyingDo: [ submenu hideAll ] ].
	^ submenu
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
