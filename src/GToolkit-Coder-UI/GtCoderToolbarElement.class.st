"
I display a {{gtClass:BrToolbar}}.
1. # Example

{{gtExample:GtCoderElementExamples>>#toolbarElementWithClass|previewExpanded|codeExpanded=false|previewHeight=700}}


"
Class {
	#name : #GtCoderToolbarElement,
	#superclass : #GtCoderNavigationModelElement,
	#instVars : [
		'toolbarElement'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #accessing }
GtCoderToolbarElement >> addButton [

	<gtCoderAction: 5>
	toolbarElement addItem: self newAddButton
]

{ #category : #'gt-extensions' }
GtCoderToolbarElement >> addClassTab: look [
	<gtCreateComponentTab: 10>
	^ BrTab new
		aptitude: BrGlamorousTabAptitude new;
		label: 'Class';
		stencil: [ | element |
			element := GtPharoCreateBehaviorElement new.
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

{ #category : #initialization }
GtCoderToolbarElement >> addCustomButtons [

	| pragmas |
	pragmas := Pragma allNamed: #gtCoderAction: in: self class.
	pragmas sort: [ :a :b | (a argumentAt: 1) <= (b argumentAt: 1) ].
	pragmas do: [ :aPragma | self perform: aPragma methodSelector ]
]

{ #category : #'gt-extensions' }
GtCoderToolbarElement >> addPackageTab: look [
	<gtCreateComponentTab: 30>
	^ BrTab new
		aptitude: BrGlamorousTabAptitude new;
		label: 'Package';
		stencil: [ | element |
			element := GtPharoCreatePackageElement new.
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
		aptitude: BrGlamorousTabAptitude new;
		label: 'Trait';
		stencil: [ | element |
			element := GtPharoCreateBehaviorElement new.
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

{ #category : #accessing }
GtCoderToolbarElement >> browseButton [

	<gtCoderAction: 1>
	toolbarElement addItem: self newBrowseButton
]

{ #category : #'private - actions' }
GtCoderToolbarElement >> browseFrom: anElement [
	"Do we want to share the same coder model?"
	self navigationModel coderDo: [ :aCoder | 
		((GtCoder forCoder: aCoder asNewCoderModelWithSameSubject)
			openInPagerFrom: anElement)
				maximized ]
]

{ #category : #accessing }
GtCoderToolbarElement >> createActionButton [

	| button caller |
	button := BrButton new.
	caller := thisContext stack second method.
	button viewModel when: BlClickEvent do: [ :anEvent | 
		(GtPhlowUtility isDefinitionRequested: anEvent) ifTrue: [ 
			anEvent consumed: true.
			button phlow spawnObject: caller ] ].
	^ button
]

{ #category : #accessing }
GtCoderToolbarElement >> hierarchyButton [

	<gtCoderAction: 3>
	toolbarElement addItem: self newHierarchyButton
]

{ #category : #initialization }
GtCoderToolbarElement >> initialize [
	super initialize.
	self initializeToolbarElement.
	
	self layout: BlLinearLayout horizontal.

	self addChild: self toolbarElement as: #toolbar.
	
	self addAptitude: (BrLayoutResizerAptitude new
		anyToFitContent;
		anyToFitContent: self toolbarElement)
]

{ #category : #initialization }
GtCoderToolbarElement >> initializeToolbarElement [
	toolbarElement := BrToolbar new
			aptitude: BrGlamorousToolbarAptitude new;
			padding: (BlInsets right: 5).
	self addCustomButtons
]

{ #category : #'private - instance creation' }
GtCoderToolbarElement >> newAddButton [
	| look |
	^ self createActionButton
		label: 'Add class or package';
		aptitude:
			BrGlamorousButtonWithIconAptitude
				+
					(look := BrGlamorousWithDropdownAptitude
						handle: [ BrButton new
								aptitude:
									BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude
										- BrGlamorousButtonExteriorAptitude;
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
	contentTabs aptitude: BrGlamorousTabGroupAptitude new.
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
GtCoderToolbarElement >> newBrowseButton [
	^ self createActionButton
		aptitude: BrGlamorousButtonWithIconAptitude;
		label: 'Browse in another world tab';
		icon: BrGlamorousVectorIcons emphasizedBrowse;
		action: [ :aButton | self browseFrom: aButton ]
]

{ #category : #'private - instance creation' }
GtCoderToolbarElement >> newHierarchyButton [
	^ self createActionButton
		label: 'Show Package and Class Hierarchies';
		aptitude: BrGlamorousButtonWithIconAptitude + (BrGlamorousWithDropdownAptitude
			handle: [
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude - BrGlamorousButtonExteriorAptitude;
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

{ #category : #initialization }
GtCoderToolbarElement >> repository [

	self navigationModel hasSelectedClass ifTrue: [ 
		^ self navigationModel selectedClass repository ].
	self navigationModel hasSelectedPackage ifTrue: [ 
		^ self navigationModel selectedPackage repository ].
	^ nil
]

{ #category : #accessing }
GtCoderToolbarElement >> spotterButton [

	<gtCoderAction: 2>
	toolbarElement addItem: self newSpotterButton
]

{ #category : #accessing }
GtCoderToolbarElement >> toolbarElement [
	<return: #BrToolbar>
	^ toolbarElement
]
