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
GtCoderToolbarElement >> addButtonFor: anAction [
	<gtAction>
	^ anAction dropdown
		icon: BrGlamorousVectorIcons add;
		tooltip: 'Add class or package';
		priority: 5;
		content: [ :aDropdown | 
			| element |
			element := BlElement new.
			element
				constraintsDo: [ :c | 
					c horizontal exact: 400.
					c vertical exact: 300 ].
			element addChild: (self newAddInterface: aDropdown).
			element ]
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
					look fireEvent: BrDropdownHideWish new.
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
	(GtPhlowActionsCollector new
		pragmaName: #gtAction;
		fromObject: self;
		collect)
		do: [ :each | 
			each
				asElement: [ :actionElement | self toolbarElement addItem: actionElement ]
				withHostElement: self ]
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
					look fireEvent: BrDropdownHideWish new.
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
					look fireEvent: BrDropdownHideWish new.
					self navigationModel selectClass: cls ].
			element forTraitDefinition.
			self navigationModel
				selectedPackageDo: [ :package | element forPackage: package ].
			self navigationModel
				selectedTagDo: [ :tag | element forPackageTag: tag ].
			element ]
]

{ #category : #accessing }
GtCoderToolbarElement >> browseButtonFor: anAction [
	<gtAction>
	^ anAction button
		tooltip: 'Browse in another world tab';
		priority: 1;
		icon: BrGlamorousVectorIcons emphasizedBrowse;
		action: [ :aButton | self browseFrom: aButton ]
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
GtCoderToolbarElement >> hierarchyButtonFor: anAction [
	<gtAction>
	^ anAction dropdown
		tooltip: 'Show Package and Class Hierarchies';
		icon: BrGlamorousIcons tree;
		priority: 3;
		content: [
				BlElement new
					size: 400@400;
					addChild: ((GtCoderNavigationTabsStencil new 
						navigationModel: navigationModel;
						asElement) background: Color white) ]
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

{ #category : #initialization }
GtCoderToolbarElement >> repository [

	self navigationModel hasSelectedClass ifTrue: [ 
		^ self navigationModel selectedClass repository ].
	self navigationModel hasSelectedPackage ifTrue: [ 
		^ self navigationModel selectedPackage repository ].
	^ nil
]

{ #category : #accessing }
GtCoderToolbarElement >> spotterButtonFor: anAction [
	<gtAction>
	^ anAction explicit
		priority: 2;
		stencil: [ GtSpotterDropdownButtonStencil new
				valuable: (GtCoderSpotterStart new navigationModelBlock: [ self navigationModel ]);
				tooltip: 'Search Code';
				actOn: [ :anActOnEvent :anItem :theButton | 
					| acted |
					acted := false.
					(anItem isKindOf: RPackage)
						ifTrue: [ self navigationModel selectPackage: anItem.
							acted := true ].
					(anItem isKindOf: ClassDescription)
						ifTrue: [ self navigationModel selectClass: anItem.
							acted := true ].
					(anItem isKindOf: CompiledMethod)
						ifTrue: [ self navigationModel selectMethod: anItem.
							acted := true ].
					acted ifTrue: [ anActOnEvent beActed ] ];
				asElement ]
]

{ #category : #accessing }
GtCoderToolbarElement >> toolbarElement [
	<return: #BrToolbar>
	^ toolbarElement
]
