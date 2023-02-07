Class {
	#name : #GtCoderNavigationTabsStencil,
	#superclass : #BrStencil,
	#instVars : [
		'navigations',
		'navigationModel',
		'formCache'
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
GtCoderNavigationTabsStencil >> formCache [
	^ formCache
]

{ #category : #accessing }
GtCoderNavigationTabsStencil >> formCache: anObject [
	formCache := anObject
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
GtCoderNavigationTabsStencil >> gtCreationInterface: look [
	| contentTabs tabClasses |
	contentTabs := BrTabGroup new.
	contentTabs aptitude: BrGlamorousTabGroupAptitude new.
	contentTabs
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	tabClasses := GtCreationForm allSubclasses
			asSortedCollection: [ :a :b | a priority < b priority ].
	tabClasses
		do: [ :each | 
			contentTabs
				addTab: (BrTab new
						aptitude: BrGlamorousTabAptitude new;
						label: each componentName;
						stencil: [ (self formCache
								at: each
								ifAbsentPut: [ | form |
									form := each new.
									form hasPackageAndTag
										ifTrue: [ navigationModel
												selectedPackageDo: [ :aPackage | form packageAndTagName packageName: aPackage name ].
											navigationModel
												selectedTagDo: [ :aTag | form packageAndTagName tagName: aTag name ] ].
									((GtCreationFormWidget forForm: form)
										onAccept: [ :anInstance | 
											look
												inUIProcessDo: [ form selectInNavigationModel: navigationModel anInstance: anInstance.
													look fireEvent: BrDropdownHideWish new ].
											self formCache removeKey: each ];
										onElementCreated: [ :aFrame | 
											BlFocusFinder new
												direction: BlFocusSearchDirectionForward new;
												root: aFrame;
												referenceElement: nil;
												nextFocusDo: #requestFocus ifNone: [  ] ]) asElement ])
								removeFromParent ]) ].
	^ contentTabs
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
			tooltip: 'Search Code';
	actionDropdownButtonIcon: BrGlamorousVectorIcons add
		tooltip: 'Add class or package'
		content: [ :aDropdown | 
			| element |
			element := BlElement new.
			element
				constraintsDo: [ :c | 
					c horizontal exact: 400.
					c vertical exact: 300 ].
			element addChild: (self gtCreationInterface: aDropdown).
			element ]
]

{ #category : #accessing }
GtCoderNavigationTabsStencil >> initialize [
	formCache := Dictionary new.
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
