Class {
	#name : #GtCoderNavigationPackagesTreeElement,
	#superclass : #BlElement,
	#instVars : [
		'navigationModel',
		'tree',
		'packagesFilterEditor'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'building ui' }
GtCoderNavigationPackagesTreeElement >> buildAddPackageButton [
	| dropdown |
	dropdown := BrDropdown new.
	^ dropdown
		look: BrGlamorousDropdownLook;
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		toggle: [ BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousIcons add asElement;
				yourself ];
		popup: [ | editor button |
			editor := BrEditor new
				look: BrGlamorousRegularEditorLook new;
				geometry: (BlRectangle cornerRadius: 4);
				border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
				hExact: 100;
				vMatchParent;
				padding: (BlInsets all: 3);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				yourself.
			button := BrButton new
				look: BrGlamorousButtonWithIconLook;
				margin: (BlInsets left: 10);
				icon: BrGlamorousIcons accept asElement;
				action: [ dropdown collapse.
					navigationModel
						packagesFilterString: (RPackageOrganizer default createPackageNamed: editor text asString) name ];
				yourself.
			BlElement new
				layout: BlLinearLayout horizontal;
				padding: (BlInsets all: 10);
				constraintsDo: [ :c | 
					c horizontal fitContent.
					c vertical fitContent ];
				addChild: editor;
				addChild: button;
				yourself ];
		yourself
]

{ #category : #'as yet unclassified' }
GtCoderNavigationPackagesTreeElement >> buildPackageTree [
	^ self buildPackageTree: RPackageOrganizer default packages
]

{ #category : #'as yet unclassified' }
GtCoderNavigationPackagesTreeElement >> buildPackageTree: somePackages [
	^ BrSimpleTree new
		items: (somePackages sort: [ :a :b | a name < b name ])
			children: [ :anObject | 
			(anObject isKindOf: RPackage)
				ifTrue: [ anObject definedClasses asOrderedCollection
						sort: [ :a :b | a name < b name ] ]
				ifFalse: [ #() ] ];
		stencil:
			(BrSimpleTreeRowStencilBuilder new
				text:
					[ :anObject | anObject name asRopedText glamorousRegularFontAndSize ]);
		in: [ :e | 
			e
				when: BrSelectionChanged
				do: [ :anEvent | 
					anEvent
						selectedDo: [ :anInterval | 
							e
								selectedNodeDo: [ :aNode | 
									aNode value isClass
										ifTrue: [ navigationModel selectInCoderClass: aNode value ].
									(aNode value isKindOf: RPackage)  
										ifTrue: [ navigationModel selectInCoderPackage: aNode value ] ] ] ] ];
		yourself
]

{ #category : #'as yet unclassified' }
GtCoderNavigationPackagesTreeElement >> buildPackagesFilterEditor [
	^ BrEditor new
		look: BrGlamorousCodeEditorLook new;
		geometry: (BlRectangle cornerRadius: 4);
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		hExact: 100;
		vMatchParent;
		padding: (BlInsets all: 3);
		text: navigationModel packagesFilterString;
		in: [ :e | 
			e editor
				when: BrTextEditorInsertedEvent
					do: [ e text asString ~= navigationModel packagesFilterString
						ifTrue: [ navigationModel packagesFilterString: e text asString ] ];
				when: BrTextEditorDeletedEvent
					do: [ e text asString ~= navigationModel packagesFilterString
						ifTrue: [ navigationModel packagesFilterString: e text asString ] ] ];
		yourself
]

{ #category : #'as yet unclassified' }
GtCoderNavigationPackagesTreeElement >> buildToolbar [
	^ BrToolbar new
		look: BrGlamorousToolbarLook new;
		addItem: (packagesFilterEditor := self buildPackagesFilterEditor);
		addItem: self buildAddPackageButton;
		yourself
]

{ #category : #initialization }
GtCoderNavigationPackagesTreeElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #accessing }
GtCoderNavigationPackagesTreeElement >> navigationModel: aNavigationModel [
	navigationModel ifNotNil: [ navigationModel unsubscribe: self ].
	navigationModel := aNavigationModel.
	navigationModel
		subscribe: GtClassCoderPackagesFilterStringChanged
		send: #updatePackageFilterEditorAndPackageTree
		to: self.
	navigationModel
		subscribe: GtClassCoderNavigationSelectionChanged
		send: #updateSelection
		to: self.
	self
		removeChildren;
		addChild: self buildToolbar;
		addChild: (tree := self buildPackageTree).
	packagesFilterEditor text: navigationModel packagesFilterString.
	navigationModel theClass
		ifNotNil: [ :aClass | self selectClass: aClass ]
]

{ #category : #accessing }
GtCoderNavigationPackagesTreeElement >> selectClass: aClass [
	self selectPackage: aClass package
]

{ #category : #accessing }
GtCoderNavigationPackagesTreeElement >> selectPackage: aPackage [
	self updatePackageFilterEditorAndPackageTree.
	tree viewModel collapseAll.
	tree viewModel root withAllChildrenNodesBreadthFirst
		detect: [ :each | each value = aPackage ]
		ifFound: [ :e | e withAllParentNodesDo: #expand ]
]

{ #category : #'as yet unclassified' }
GtCoderNavigationPackagesTreeElement >> updatePackageFilterEditorAndPackageTree [
	packagesFilterEditor text: navigationModel packagesFilterString.
	tree removeFromParent.
	tree := self
		buildPackageTree:
			(RPackageOrganizer default packages
				select: [ :g | 
					g name asLowercase
						includesSubstring: navigationModel packagesFilterString asLowercase ]).
	self addChild: tree
]

{ #category : #callbacks }
GtCoderNavigationPackagesTreeElement >> updateSelection [
	tree selectedNodeDo: [ :selectionNode |
		selectionNode value = navigationModel selectedObject ifTrue: [ 
			"If the object selected in the model is the same as the one selected
			in the tree do not select it again."
			^ self ] ].
	
	tree viewModel root allChildrenNodesBreadthFirstDo: [ :treeNode |
		treeNode ensureChildNodesComputed.
		navigationModel selectedObject = treeNode value ifTrue: [ 
			treeNode withAllParentNodesDo: [ :node | node expand ].
			tree selectOne: treeNode globalIndexInTree ] ]
]
