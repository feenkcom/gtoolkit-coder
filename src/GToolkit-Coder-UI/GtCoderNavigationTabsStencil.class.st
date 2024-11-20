Class {
	#name : #GtCoderNavigationTabsStencil,
	#superclass : #BrStencil,
	#instVars : [
		'navigations',
		'navigationModel',
		'formCache',
		'pragmaName'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #'gt-extensions' }
GtCoderNavigationTabsStencil >> addButtonsTo: explicitView [
	explicitView
		actionStencil: [ :aButton | 
			GtSpotterDropdownButtonStencil new
				valuable: (GtCoderSpotterStart new navigationModelBlock: [ self navigationModel ]);
				tooltip: 'Search Code';
				objectActOn: [ :anActOnEvent :anItem :theButton | 
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
				id: GtNavigationSpotterDropdownId;
				asElement ]
		tooltip: 'Search Code'.
	explicitView
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
			aDropdown
				when: GtNavigationDropDownCreateWish
				do: [ :aWish | element children first selectTabWithLabelString: aWish tabName ].
			element ]
		id: GtNavigationNewDropdownId
]

{ #category : #adding }
GtCoderNavigationTabsStencil >> addNavigation: aNavigationElement [
	self assertNavigationView: aNavigationElement.
	self navigations: (self navigations copyWith: aNavigationElement)
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
		pragmaName: self pragmaName;
		collect
]

{ #category : #defaults }
GtCoderNavigationTabsStencil >> defaultPragmaName [
	^ #gtCoderNavigation
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
GtCoderNavigationTabsStencil >> gtClassDropdownHierarchyFor: aView [
	<gtCoderDropdownNavigation>
	| explicitView |
	self navigationModel ifNil: [ ^ aView empty ].
	explicitView := aView explicit
			title: 'Class Hierarchy';
			priority: 2;
			stencil: [ GtCoderNavigationBasicClassHierarchyElement new
					navigationModel: self navigationModel ].
	self addButtonsTo: explicitView.
	^ explicitView
]

{ #category : #'gt-extensions' }
GtCoderNavigationTabsStencil >> gtClassHierarchyFor: aView [
	<gtCoderNavigation>
	| explicitView |
	self navigationModel ifNil: [ ^ aView empty ].
	explicitView := aView explicit
			title: 'Class Hierarchy';
			priority: 2;
			stencil: [ GtCoderNavigationClassHierarchyElement new
					navigationModel: self navigationModel ].
	self addButtonsTo: explicitView.
	^ explicitView
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
	tabClasses := (GtCreationForm allSubclasses
			select: [ :aClass | 
				(aClass isAbstract or: [ aClass hasAbstractMethods ]) not
					and: [ aClass isAdditionForm ] ])
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
									form := each new
											onReset: [ look
													inUIProcessDo: [ look fireEvent: BrDropdownHideWish new.
														self formCache removeKey: each ] ].
									form class == GtClassCreationForm
										ifTrue: [ navigationModel
												selectedClassDo: [ :aClass | aClass isClass ifTrue: [ form superclassName: aClass name ] ] ].
									form hasPackageAndTag
										ifTrue: [ navigationModel
												selectedPackageDo: [ :aPackage | form packageAndTagName packageName: aPackage name ].
											navigationModel
												selectedTagDo: [ :aTag | 
													(aTag isKindOf: RPackageTag)
														ifTrue: [ aTag isRoot ifFalse: [ form packageAndTagName tagName: aTag name ] ]
														ifFalse: [ aTag isUncategorized ifFalse: [ form packageAndTagName tagName: aTag name ] ] ] ].
									((GtCreationFormWidget forForm: form)
										onAccept: [ :anInstance | 
											look
												inUIProcessDo: [ form selectInNavigationModel: navigationModel anInstance: anInstance.
													look fireEvent: BrDropdownHideWish new ].
											self formCache removeKey: each ifAbsent: [  ] ]) asElement ])
								removeFromParent ]) ].
	^ contentTabs
]

{ #category : #'gt-extensions' }
GtCoderNavigationTabsStencil >> gtPackagesTagsClassesDropdownFor: aView [
	<gtCoderDropdownNavigation>
	| explicitView |
	self navigationModel ifNil: [ ^ aView empty ].
	explicitView := aView explicit
			title: 'Package Hierarchy';
			priority: 1;
			stencil: [ GtCoderNavigationBasicPackagesTagsClassesElement new
					navigationModel: self navigationModel ].
	self addButtonsTo: explicitView.
	^ explicitView
]

{ #category : #'gt-extensions' }
GtCoderNavigationTabsStencil >> gtPackagesTagsClassesFor: aView [
	<gtCoderNavigation>
	| explicitView |
	self navigationModel ifNil: [ ^ aView empty ].
	explicitView := aView explicit
			title: 'Package Hierarchy';
			priority: 1;
			stencil: [ GtCoderNavigationPackagesTagsClassesElement new
					navigationModel: self navigationModel ].
	self addButtonsTo: explicitView.
	^ explicitView
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

{ #category : #accessing }
GtCoderNavigationTabsStencil >> pragmaName [
	^ pragmaName ifNil: [ pragmaName := self defaultPragmaName ]
]

{ #category : #accessing }
GtCoderNavigationTabsStencil >> pragmaName: anObject [
	pragmaName := anObject
]
