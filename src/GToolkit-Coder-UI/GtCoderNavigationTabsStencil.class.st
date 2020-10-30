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
			navigationModel: self navigationModel ]
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
