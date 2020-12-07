"
I display a ${class:BrToolbar}$.
!! Example
${example:GtCoderElementExamples>>#toolbarElementWithClass|previewExpanded|codeExpanded=false|previewHeight=700}$

"
Class {
	#name : #GtCoderToolbarElement,
	#superclass : #GtCoderNavigationModelElement,
	#instVars : [
		'toolbarElement'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'gt-extensions' }
GtCoderToolbarElement >> addClassTab: look [
	<gtCreateComponentTab: 10>
	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Class';
		stencil: [ | element |
			element := GtCreateBehaviorElement new.
			element
				behaviorBlock: [ :cls | 
					look hide.
					navigationModel selectClass: cls ].
			element forClassDefinition.
			navigationModel
				selectedPackageDo: [ :package | element forPackage: package ].
			navigationModel
				selectedTagDo: [ :tag | element forPackageTag: tag ].
			element ]
]

{ #category : #'gt-extensions' }
GtCoderToolbarElement >> addPackageTab: look [
	<gtCreateComponentTab: 30>
	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Package';
		stencil: [ | element |
			element := GtCreatePackageElement new.
			element
				packageBlock: [ :pkg :tag | 
					look hide.
					tag isNil
						ifTrue: [ self navigationModel selectPackage: pkg ]
						ifFalse: [ self navigationModel selectPackageTag: tag ] ].
			self navigationModel
				selectedPackageDo: [ :package | element forPackage: package ].
			element ]
]

{ #category : #'gt-extensions' }
GtCoderToolbarElement >> addTraitTab: look [
	<gtCreateComponentTab: 20>
	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Trait';
		stencil: [ | element |
			element := GtCreateBehaviorElement new.
			element
				behaviorBlock: [ :cls | 
					look hide.
					self navigationModel selectClass: cls ].
			element forTraitDefinition.
			self navigationModel
				selectedPackageDo: [ :package | element forPackage: package ].
			self navigationModel
				selectedTagDo: [ :tag | element forPackageTag: tag ].
			element ]
]

{ #category : #initialization }
GtCoderToolbarElement >> initialize [
	super initialize.
	self initializeToolbarElement.
	
	self layout: BlLinearLayout horizontal.

	self addChild: self toolbarElement as: #toolbar.
	
	self addLook: (BrLayoutResizerLook new
		anyToFitContent;
		anyToFitContent: self toolbarElement)
]

{ #category : #initialization }
GtCoderToolbarElement >> initializeToolbarElement [
	toolbarElement := BrToolbar new
		look: BrGlamorousToolbarLook new;
		padding:
			(BlInsets
				top: 10
				left: 0
				bottom: 0
				right: 5);
		addItem: self newSpotterButton;
		addItem: self newHierarchyButton;
		addItem: self newAddButton;
		yourself
]

{ #category : #'private - instance creation' }
GtCoderToolbarElement >> newAddButton [
	| look |
	^ BrButton new
		label: 'Add class or package';
		look:
			BrGlamorousButtonWithIconLook
				+
					(look := BrGlamorousWithDropdownLook
						handle: [ BrButton new
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousVectorIcons add;
								yourself ]
						content: [ | element |
							element := BlElement new.
							element
								constraintsDo: [ :c | 
									c horizontal exact: 400.
									c vertical exact: 300 ].
							element addChild: (self newAddInterface: look).
							element ]);
		icon: BrGlamorousVectorIcons add;
		yourself
]

{ #category : #'private - instance creation' }
GtCoderToolbarElement >> newAddInterface: look [
	| contentTabs tabMethods |
	contentTabs := BrTabGroup new.
	contentTabs look: BrGlamorousTabGroupLook new.
	contentTabs
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	tabMethods := (Pragma allNamed: #gtCreateComponentTab: in: self class)
		asSortedCollection: [ :a :b | a arguments first < b arguments first ].
	tabMethods
		do:
			[ :each | contentTabs addTab: (self perform: each method selector with: look) ].
	^ contentTabs
]

{ #category : #'private - instance creation' }
GtCoderToolbarElement >> newHierarchyButton [
	^ BrButton new
		label: 'Show Package and Class Hierarchies';
		look: BrGlamorousButtonWithIconLook + (BrGlamorousWithDropdownLook
			handle: [
				BrButton new
					look: BrGlamorousButtonWithIconLook - BrGlamorousButtonWithLabelTooltipLook - BrGlamorousButtonExteriorLook;
					icon: BrGlamorousIcons tree;
					yourself ]
			content: [
				BlElement new
					size: 400@400;
					addChild: ((GtCoderNavigationTabsStencil new 
						navigationModel: navigationModel;
						asElement) background: Color white) ]);
		icon: BrGlamorousIcons tree asElement;
		yourself
]

{ #category : #'private - instance creation' }
GtCoderToolbarElement >> newSpotterButton [
	<return: #BrButton>
	
	^ GtSpotterDropdownButtonStencil new
		valuable: (GtCoderSpotterStart new navigationModelBlock: [self navigationModel]);
		tooltip: 'Search Code';
		actOn: [ :anActOnEvent :anItem :theButton | 
			| acted |
			acted := false.
			(anItem isKindOf: RPackage) ifTrue: [ 
				self navigationModel selectPackage: anItem. acted := true ].
			(anItem isKindOf: ClassDescription) ifTrue: [ 
				self navigationModel selectClass: anItem. acted := true ].
			(anItem isKindOf: CompiledMethod) ifTrue: [ 
				self navigationModel selectMethod: anItem. acted := true ].
			acted ifTrue: [ anActOnEvent beActed ] ];
		asElement.
]

{ #category : #accessing }
GtCoderToolbarElement >> toolbarElement [
	<return: #BrToolbar>
	^ toolbarElement
]
