Class {
	#name : #GtCoderProtocolsSlotsTabGroupElement,
	#superclass : #BrTabGroup,
	#instVars : [
		'methodProtocolsList',
		'slotsGroupList'
	],
	#category : #'GToolkit-Coder-UI-Navigation - Helpers'
}

{ #category : #initialization }
GtCoderProtocolsSlotsTabGroupElement >> initialize [
	super initialize.
	
	self aptitude: BrGlamorousTabGroupProportionalAptitude - BrTabGroupSplitterAptitude;
			addTab: (BrTab new
					hMatchParent;
					aptitude: GtProtocolSlotTabAptitude new;
					label: 'Categories' asRopedText glamorousCodeSmallSize;
					stencil: [ methodProtocolsList ]);
			addTab: (BrTab new
					hMatchParent;
					aptitude: GtProtocolSlotTabAptitude new;
					label: 'Slots' asRopedText glamorousCodeSmallSize;
					stencil: [ slotsGroupList ])
]
