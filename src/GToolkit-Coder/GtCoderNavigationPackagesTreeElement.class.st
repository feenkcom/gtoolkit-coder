Class {
	#name : #GtCoderNavigationPackagesTreeElement,
	#superclass : #BlElement,
	#instVars : [
		'navigationModel',
		'tree'
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
					self
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
					[ :anObject | anObject value name asRopedText glamorousRegularFontAndSize ]);
		in: [ :e | 
			e
				when: BrSelectionChanged
				do: [ :anEvent | 
					anEvent
						selectedDo: [ :anInterval | 
							e
								selectedNodeDo: [ :aNode | 
									aNode value isClass
										ifTrue: [ navigationModel selectInCoderClass: aNode value ] ] ] ] ];
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
		text: (navigationModel packagesFilterString ifNil: [ '' ]);
		in: [ :e | 
			e editor
				when: BrTextEditorInsertedEvent
					do: [ self packagesFilterString: e text asString ];
				when: BrTextEditorDeletedEvent
					do: [ self packagesFilterString: e text asString ] ];
		yourself
]

{ #category : #'as yet unclassified' }
GtCoderNavigationPackagesTreeElement >> buildToolbar [
	^ BrToolbar new
		look: BrGlamorousToolbarLook new;
		addItem: self buildPackagesFilterEditor;
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
	navigationModel := aNavigationModel.
	self
		removeChildren;
		addChild: self buildToolbar;
		addChild: (tree := self buildPackageTree).
	navigationModel packagesFilterString
		ifNotNil: [ :e | self packagesFilterString: e ].
	navigationModel theClass
		ifNotNil: [ :aClass | self selectClass: aClass ]
]

{ #category : #'as yet unclassified' }
GtCoderNavigationPackagesTreeElement >> packagesFilterString: aString [
	navigationModel packagesFilterString: aString.
	tree removeFromParent.
	tree := self
		buildPackageTree:
			(RPackageOrganizer default packages
				select: [ :g | g name asLowercase includesSubstring: aString asLowercase ]).
	self addChild: tree
]

{ #category : #accessing }
GtCoderNavigationPackagesTreeElement >> selectClass: aClass [
	self selectPackage: aClass package
]

{ #category : #accessing }
GtCoderNavigationPackagesTreeElement >> selectPackage: aPackage [
	navigationModel packagesFilterString
		ifNil: [ self packagesFilterString: aPackage name ].
	tree viewModel root childrenNodes
		detect: [ :each | each value = aPackage ]
		ifFound: [ :aTreeNode | 
			aTreeNode isExpanded
				ifFalse: [ aTreeNode expand ] ]
]
