"
I show a list of classes grouping them based on the inheritance hierarchy and sorting alphabetically


"
Class {
	#name : #GtCoderNavigationClassesHierarchyTreeElement,
	#superclass : #BrSimpleTree,
	#instVars : [
		'classesTree'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'instance creation' }
GtCoderNavigationClassesHierarchyTreeElement class >> fromClasses: aCollectionOfClasses [
	^ self new initializeWithClasses: aCollectionOfClasses
]

{ #category : #accessing }
GtCoderNavigationClassesHierarchyTreeElement >> addPreviewButtonFor: refactoring to: elem [
	| button |
	elem removeChildNamed: #preview.
	button := GtRefactoringsPreviewButton new.
	button vMatchParent.
	button refactorings: [ {refactoring} ].
	button cancelBlock: [  ].
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
GtCoderNavigationClassesHierarchyTreeElement >> classListContextMenuItemsFor: aClass [ 
	^{(self createLabel: 'Rename class' description: aClass name)
			-> [ :elem | self renameClass: aClass inElement: elem ].
		(self createLabel: 'Remove class' description: aClass name)
			-> [ :elem | self removeClass: aClass inElement: elem ]}
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> createLabel: aString description: description [
	^ aString asRopedText glamorousRegularFont
		, ((' ' , description) asRopedText
				glamorousCodeFont;
				foreground: Color gray;
				glamorousCodeTinySize)
]

{ #category : #'private - ui' }
GtCoderNavigationClassesHierarchyTreeElement >> expandClass: aClass [
	| aClassDepth |
	aClassDepth := 0.
	aClass
		allSuperclassesDo: [ :eachClass | aClassDepth := aClassDepth + 1 ].
	self expandUpTo: aClassDepth + 1
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> initialize [
	super initialize.

	self rowStencil: BrGlamorousSimpleTreeSelectableRowElementStencilBuilder new.

	self
		nodeStencil: [ BrHorizontalPane new
				aptitude: BrGlamorousListItemAptitude;
				hMatchParent;
				vFitContent ];
		nodeDataBinder: [ :aClassElement :aClassHierarchyTree | 
			| label |
			aClassElement removeChildren.
			label := BrLabel new
					beSmallSize;
					aptitude: BrGlamorousLabelAptitude.
			aClassElement addChild: label.
			aClassHierarchyTree
						ifNil: [ label text: '' asRopedText]
						ifNotNil: [ | aClass aText |
							aClass := aClassHierarchyTree rootClass.
							aText := aClass gtDisplayText asRopedText.
							(aClass isAbstract or: [ aClass hasAbstractMethods ])
								ifTrue: [ aText italic ].
							aClass isDeprecated
								ifTrue: [ aText append: ' (deprecated)' asRopedText italic ].
							label text: aText.
							 label
					addAptitude: (BrGlamorousWithContextMenuAptitude
							content: [ GtCoderNavigationContextMenuContent new
									items: (self classListContextMenuItemsFor: aClass) ]).].
		 ]
]

{ #category : #'api - initialization' }
GtCoderNavigationClassesHierarchyTreeElement >> initializeWithClasses: aCollectionOfClasses [
	classesTree := (GtCoderClassesHierarchyTree
		fromClasses: aCollectionOfClasses) sortByClassName.
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
GtCoderNavigationClassesHierarchyTreeElement >> removeClass: aClass inElement: elem [
	| change button |
	change := RBRemoveClassChange remove: aClass.
	button := GtPreviewChangeButton new
			icon: BrGlamorousVectorIcons remove;
			label: 'Remove';
			changeAction: [ change execute ];
			changeStencil: [ self buildRemoveClassLabelFor: aClass ].
	button
		when: GtRefactoringsAppliedEvent
		do: [ :anEvent | elem removeChild: anEvent currentTarget ].
	^ elem addChild: button as: #preview
]

{ #category : #initialization }
GtCoderNavigationClassesHierarchyTreeElement >> renameClass: aClass inElement: elem [ 
	| refactoring edit |
	edit := BrEditableLabel new.
	edit
		aptitude: (BrGlamorousEditableLabelAptitude new
				glamorousCodeSmallSize;
				background: Color transparent);
		text: aClass name;
		when: BrEditorAcceptWish
			do: [ :aWish | 
				refactoring := RBRenameClassRefactoring
						rename: aClass name
						to: aWish text asString.
				edit switchToLabel.
				self addPreviewButtonFor: refactoring to: elem ];
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
