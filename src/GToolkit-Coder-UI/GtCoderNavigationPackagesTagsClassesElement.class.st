Class {
	#name : #GtCoderNavigationPackagesTagsClassesElement,
	#superclass : #GtCoderNavigationBasicPackagesTagsClassesElement,
	#traits : 'TGtCoderNavigationWithContextMenu',
	#classTraits : 'TGtCoderNavigationWithContextMenu classTrait',
	#instVars : [
		'methodProtocolsList',
		'methodsLabel',
		'methodGroupList',
		'slotsGroup',
		'slotsGroupList'
	],
	#category : 'GToolkit-Coder-UI-Navigation'
}

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildCategorySlotTabs [
	| aTabGroup |
	aTabGroup := BrTabGroup new
			aptitude: BrGlamorousTabGroupProportionalAptitude - BrTabGroupSplitterAptitude;
			addTab: (BrTab new
					hMatchParent;
					aptitude: GtProtocolSlotTabAptitude new;
					label: 'Categories' asRopedText glamorousCodeSmallSize;
					stencil: [ methodProtocolsList ]);
			addTab: (BrTab new
					id: #slots;
					hMatchParent;
					aptitude: GtProtocolSlotTabAptitude new;
					label: 'Slots' asRopedText glamorousCodeSmallSize;
					stencil: [ slotsGroupList ]).

	^ aTabGroup
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildGroupList [
	^ BrGroupedList new
		padding: (BlInsets left: 5 right: 10);
		matchParent;
		headerElementStencil: [ BrLabel new
				beSmallSize;
				aptitude: (BrGlamorousLabelAptitude new foreground: Color gray) ];
		headerDataBinder: [ :label :each | label text: each domainObject asRopedText ]
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildMethodGroupList [
	^ GtCoderMethodsGroupedListElement multiSelection
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildProtocolGroupList [
	^ GtCoderProtocolsGroupedListElement new
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> buildSlotsGroupList [
	^ GtCoderSlotsGroupedListElement new
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> initializeContent [
	super initializeContent.
	methodProtocolsList := self buildProtocolGroupList.
	slotsGroupList := self buildSlotsGroupList.
	methodGroupList := self buildMethodGroupList
]

{ #category : #initialization }
GtCoderNavigationPackagesTagsClassesElement >> initializeElement [
	| pane3 pane4 |
	super initializeElement.
	pane3 := BrVerticalPane new
			addAptitude: BrGlamorousWithHorizontalResizerAptitude;
			matchParent;
			addChildren: {self buildCategorySlotTabs}.

	pane4 := BrVerticalPane new
			matchParent;
			addChildren: {methodsLabel := self headerLabel text: 'Methods'.
					methodGroupList}.
	self
		addChildren: {pane3.
				pane4}
]

{ #category : #'private - accessing' }
GtCoderNavigationPackagesTagsClassesElement >> methodProtocolsList [
	^ methodProtocolsList
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onMethodsCoderFiltersChanged: aGtCodersFiltersChanged [
	aGtCodersFiltersChanged source = self ifTrue: [ ^ self ].
	methodProtocolsList
		selectedItemDo: [ :aSelectedItem | 
			| aCategoryFilter |
			aCategoryFilter := GtSearchMethodCategoryFilter
					forCategory: aSelectedItem name.

			aGtCodersFiltersChanged filters
				do: [ :eachFilter | eachFilter = aCategoryFilter ifTrue: [ ^ self ] ] ].

	aGtCodersFiltersChanged filters
		do: [ :eachFilter | 
			eachFilter class = GtSearchMethodCategoryFilter
				ifTrue: [ methodProtocolsList items
						doWithIndex: [ :aProtocol :anIndex | 
							aProtocol name = eachFilter category
								ifTrue: [ self
										suppressListChangeEventsDuring: [ methodProtocolsList selectOne: anIndex ].
									^ self ] ] ] ].

	self suppressListChangeEventsDuring: [ methodProtocolsList deselectAll ]
]

{ #category : #'event handling' }
GtCoderNavigationPackagesTagsClassesElement >> onNavigationModelChanged [
	methodProtocolsList navigationModel: self navigationModel.
	slotsGroupList navigationModel: self navigationModel.
	methodGroupList navigationModel: self navigationModel.

	super onNavigationModelChanged
]

{ #category : #'private - accessing' }
GtCoderNavigationPackagesTagsClassesElement >> selectedProtocol [
	^ self navigationModel selectedProtocol
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateProtocolList [
	methodProtocolsList updateProtocolsList
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateSelections [
	self hasNavigationModel ifFalse: [ ^ self ].
	navigationModel hasSelectedPackage
		ifTrue: [ navigationModel hasSelectedClass
				ifTrue: [ self
						selectClass: navigationModel selectedClass
						inPackage: navigationModel selectedPackage
						tag: navigationModel selectedTag ]
				ifFalse: [ self
						selectPackage: navigationModel selectedPackage
						tag: navigationModel selectedTag ] ]
]

{ #category : #'updating lists' }
GtCoderNavigationPackagesTagsClassesElement >> updateSlotList [
	slotsGroupList updateSlotList
]
