Class {
	#name : #GtCoderNavigationTabsStencil,
	#superclass : #BrStencil,
	#instVars : [
		'navigations',
		'navigationModel'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #adding }
GtCoderNavigationTabsStencil >> addNavigation: aNavigationElement [
	self assertNavigationView: aNavigationElement.
	self navigations: (self navigations copyWith: aNavigationElement)
]

{ #category : #asserting }
GtCoderNavigationTabsStencil >> assertNavigationModel: aGtCoderNavigationPackagesTagsClassesModel [
	self 
		assert: [ aGtCoderNavigationPackagesTagsClassesModel isNotNil ] 
		description: [ 'Navigation model must be non-nil' ].
]

{ #category : #asserting }
GtCoderNavigationTabsStencil >> assertNavigationView: aNavigationView [
	self 
		assert: [ aNavigationView isKindOf: GtPhlowProtoView ] 
		description: [ 'Navigation must be kind of ', GtPhlowView name ].
]

{ #category : #'api - instantiation' }
GtCoderNavigationTabsStencil >> create [
	<return: #BrTabGroup>
	^ GtPhlowCompositeView new
		views: self navigations;
		asElementDo: [ :aTabGroup | 
			aTabGroup 
				background: BrGlamorousColors neutralBackgroundColor;
				matchParent ]
]

{ #category : #defaults }
GtCoderNavigationTabsStencil >> defaultNavigations [
	<return: #Array of: #GtPhlowView>
	^ GtPhlowViewsCollector new
		fromObject: self;
		pragmaName: #gtCoderNavigation;
		collect
]

{ #category : #accessing }
GtCoderNavigationTabsStencil >> gtAddClassTab: look [
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
			navigationModel selectedPackageDo: [ :package | element forPackage: package ].
			navigationModel selectedTagDo: [ :tag | element forPackageTag: tag ].
			element ]
]

{ #category : #accessing }
GtCoderNavigationTabsStencil >> gtAddInterface: look [
	| contentTabs tabMethods |
	contentTabs := BrTabGroup new.
	contentTabs aptitude: BrGlamorousTabGroupAptitude new.
	contentTabs
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	tabMethods := (Pragma allNamed: #gtCreateComponentTab: from: self class to: Behavior)
		asSortedCollection: [ :a :b | a arguments first < b arguments first ].
	tabMethods
		do:
			[ :each | contentTabs addTab: (self perform: each method selector with: look) ].
	^ contentTabs
]

{ #category : #accessing }
GtCoderNavigationTabsStencil >> gtAddPackageTab: look [
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
						ifTrue: [ navigationModel selectPackage: pkg ]
						ifFalse: [ navigationModel selectPackageTag: tag ] ].
			navigationModel selectedPackageDo: [ :package | element forPackage: package ].
			element ]
]

{ #category : #accessing }
GtCoderNavigationTabsStencil >> gtAddTraitTab: look [
	<gtCreateComponentTab: 20>
	^ BrTab new
		aptitude: BrGlamorousTabAptitude new;
		label: 'Trait';
		stencil: [ | element |
			element := GtPharoCreateBehaviorElement new.
			element
				behaviorBlock: [ :cls | 
					look fireEvent: BrDropdownHideWish new.
					navigationModel selectClass: cls ].
			element forTraitDefinition.
			navigationModel selectedPackageDo: [ :package | element forPackage: package ].
			navigationModel selectedTagDo: [ :tag | element forPackageTag: tag ].
			element ]
]

{ #category : #'gt-extensions' }
GtCoderNavigationTabsStencil >> gtClassHierarchyFor: aView [
	<gtCoderNavigation>
	self navigationModel ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Class Hierarchy';
		priority: 2;
		stencil: [ GtCoderNavigationClassHierachyElement new navigationModel: self navigationModel ]
]

{ #category : #'gt-extensions' }
GtCoderNavigationTabsStencil >> gtPackagesTagsClassesFor: aView [
	<gtCoderNavigation>
	self navigationModel ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Package Hierarchy';
		priority: 1;
		stencil: [ GtCoderNavigationPackagesTagsClassesElement new
				navigationModel: self navigationModel ];
		actionStencil: [ :aButton | 
				GtSpotterDropdownButtonStencil new
					valuable: (GtCoderSpotterStart new
							navigationModelBlock: [ self navigationModel ]);
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
			tooltip: 'Search Code'
]

{ #category : #accessing }
GtCoderNavigationTabsStencil >> navigationModel [
	<return: #GtCoderNavigationPackagesTagsClassesModel>

	^ navigationModel
]

{ #category : #accessing }
GtCoderNavigationTabsStencil >> navigationModel: aGtCoderNavigationPackagesTagsClassesModel [
	self assertNavigationModel: aGtCoderNavigationPackagesTagsClassesModel.
	navigationModel := aGtCoderNavigationPackagesTagsClassesModel.
]

{ #category : #accessing }
GtCoderNavigationTabsStencil >> navigations [
	^ navigations ifNil: [ navigations := self defaultNavigations ]
]

{ #category : #accessing }
GtCoderNavigationTabsStencil >> navigations: anArrayOfPhlowViews [
	navigations := anArrayOfPhlowViews
]
