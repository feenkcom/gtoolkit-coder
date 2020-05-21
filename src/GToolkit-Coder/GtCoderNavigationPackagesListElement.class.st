"
I show a simple list of packages sorting alphabetically
"
Class {
	#name : #GtCoderNavigationPackagesListElement,
	#superclass : #BrSimpleTree,
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #'instance creation' }
GtCoderNavigationPackagesListElement class >> fromPackages: aCollectionOfPackages [
	^ self new initializeWithPackages: aCollectionOfPackages
]

{ #category : #'private - ui' }
GtCoderNavigationPackagesListElement >> buildPackageLabel: anRPackage [
	| aLabel |
	aLabel := BrLabel new
		look: (BrGlamorousLabelLook new fontSize: 12);
		text: anRPackage name.
	^ aLabel
]

{ #category : #'private - ui' }
GtCoderNavigationPackagesListElement >> buildPackageRow: aTreeNode index: aRowIndex tree: aTreeElement [
	^ BrWidgetContainer new
		viewModelDo: [ :aBrInteractiveModel |
			(aBrInteractiveModel addStates: {
				BrHoverModel new.
				BrPressModel new.
				BrSelectModel new }) ];
		alignCenterLeft;
		layout: BlLinearLayout horizontal;
		look: BrHorizontalPaneLook new + (BrInteractiveCommonLook new
			default: [ :aWidget | aWidget background: Color transparent ];
			hovered: [ :aWidget | aWidget background: BrGlamorousColors neutralBackgroundColor ];
			selected: [ :aWidget | aWidget background: BrGlamorousColors neutralBackgroundColor ];
			pressed: [ :aWidget | aWidget background: BrGlamorousColors neutralBackgroundColor slightlyDarker ];
			focused: [ :aWidget | aWidget border: (BlBorder paint: BrGlamorousColors primaryBorderColor width: 1) ]);
		when: BlMouseDownEvent do: [ :anEvent |
			anEvent consumed: true.
			aTreeElement selectOne: aRowIndex dueTo: anEvent.
			aTreeElement requestFocus ];
		hMatchParent;
		vFitContent;
		padding: (BlInsets left: 3 + (aTreeNode depth * 10));
		addChild: (self createExpandCollapseElementFor: aTreeNode);
		addChild: (aTreeNode depth > 1
			ifTrue: [ self buildPackageLabel: aTreeNode value ]
			ifFalse: [ self buildTagLabel: aTreeNode value ])
]

{ #category : #'private - ui' }
GtCoderNavigationPackagesListElement >> buildTagLabel: anRPackageTag [
	| aLabel |
	aLabel := BrLabel new
		look: (BrGlamorousLabelLook new fontSize: 12);
		text: anRPackageTag name.
	^ aLabel
]

{ #category : #'private - enumeration' }
GtCoderNavigationPackagesListElement >> childrenForPackageOrTag: eachPackageOrTag [
	| theTags anExtension |
	(eachPackageOrTag isKindOf: RPackage) ifFalse: [ ^ #() ].
	theTags := eachPackageOrTag classTags asArray sorted: [ :tagA :tagB | tagA name < tagB name ].
	anExtension := GtCoderPackageExtentionTag forPackage: eachPackageOrTag.
	anExtension hasExtendedClasses ifTrue: [ 
		theTags := theTags copyWith: anExtension ].
	"Do not return an only tag of the same name as the package"
	theTags size = 1 ifTrue: [ ^ #() ].
	^ theTags
]

{ #category : #'private - ui' }
GtCoderNavigationPackagesListElement >> createArrowInterationElementForNode: aNode [
	^ BlElement new
		background: (aNode isEmpty ifTrue: [ Color transparent ] ifFalse: [ Color gray ]);
		size: 10@10;
		relocate: (aNode isExpanded ifTrue: [ 1@2 ] ifFalse: [ 2@1 ]);
		geometry: (aNode isExpanded
			ifTrue: [ BlPolygon vertices: { 2@2 . 8@2 . 5@8 } ]
			ifFalse: [ BlPolygon vertices: { 2@2 . 8@5 . 2@8 } ])
]

{ #category : #'private - ui' }
GtCoderNavigationPackagesListElement >> createExpandCollapseElementFor: aNode [
	^ BlElement new
		geometry: BlEllipse new;
		margin: (BlInsets all: 2);
		size: 12@12;
		viewModel: (BrWidgetModel new 
			addAll: { 
				BrButtonModel new action: [ aNode toggle ].
				BrInteractiveModel new addStates: (
					aNode isEmpty
						ifTrue: [ #() ]
						ifFalse: [ { BrHoverModel new . BrPressModel new } ]
				), { BrEnablementModel new disabled: aNode isEmpty } });
		look: (BrInteractiveCommonLook new
			default: [ :aWidget | aWidget background: (Color transparent) ];
			hovered: [ :aWidget | aWidget background: (Color gray alpha: 0.1) ];
			pressed: [ :aWidget | aWidget background: (Color gray alpha: 0.2) ]);
		addChild: (self createArrowInterationElementForNode: aNode)
]

{ #category : #initialization }
GtCoderNavigationPackagesListElement >> initialize [
	super initialize.
	
	self stencil: [ :aBrTreeNode :anIndex :aTreeWidget |
		self buildPackageRow: aBrTreeNode index: anIndex tree: aTreeWidget ]
]

{ #category : #initialization }
GtCoderNavigationPackagesListElement >> initializeWithPackages: aCollectionOfPackages [
	| theSortedPackages |

	theSortedPackages := aCollectionOfPackages asArray
		sorted: [ :packageA :packageB | packageA name < packageB name ].

	self
		items: theSortedPackages
		children: [ :eachPackageOrTag |
			self childrenForPackageOrTag: eachPackageOrTag ]
]
