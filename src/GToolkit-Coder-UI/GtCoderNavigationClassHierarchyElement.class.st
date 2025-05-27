"
I show a list of classes grouping them based on the inheritance hierarchy and sorting alphabetically.


"
Class {
	#name : #GtCoderNavigationClassHierarchyElement,
	#superclass : #GtCoderNavigationBasicClassHierarchyElement,
	#instVars : [
		'methodsList',
		'protocolsList',
		'slotsList'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #initialization }
GtCoderNavigationClassHierarchyElement >> initialize [
	| protocolsSlotsTabGroup pane2 pane3 |
	super initialize.
	
	protocolsList := GtCoderProtocolsGroupedListElement new.
	slotsList := GtCoderSlotsGroupedListElement new.
	methodsList := GtCoderMethodsGroupedListElement multiSelection.
	
	protocolsSlotsTabGroup := BrTabGroup new
		aptitude: BrGlamorousTabGroupProportionalAptitude - BrTabGroupSplitterAptitude;
		addTab: (BrTab new
				hMatchParent;
				aptitude: GtProtocolSlotTabAptitude new;
				label: 'Categories' asRopedText glamorousCodeSmallSize;
				stencil: [ protocolsList ]);
		addTab: (BrTab new
				hMatchParent;
				aptitude: GtProtocolSlotTabAptitude new;
				label: 'Slots' asRopedText glamorousCodeSmallSize;
				stencil: [ slotsList ]).

	pane2 := BrVerticalPane new
			addAptitude: BrGlamorousWithHorizontalResizerAptitude;
			matchParent;
			addChildren: {
				protocolsSlotsTabGroup }.

	pane3 := BrVerticalPane new
					matchParent;
					addChildren: {
						self headerLabel text: 'Methods'.
						methodsList}.

	self
		addChildren: {
				pane2.
				pane3}

]

{ #category : #'event handling' }
GtCoderNavigationClassHierarchyElement >> onNavigationModelChanged [
	"subclasses may perform actions on navigation model changes"
	super onNavigationModelChanged.
	
	protocolsList navigationModel: self navigationModel.
	protocolsList updateProtocolListWith: self navigationModel protocolsToShow.
	self navigationModel selectedProtocol
		ifNotNil: [ :aProtocol | protocolsList selectProtocol: aProtocol ].

	slotsList navigationModel: self navigationModel.
	methodsList navigationModel: self navigationModel
]
