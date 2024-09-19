Class {
	#name : #GtCoderNavigationProtocolsGroupedList,
	#superclass : #BrGroupedList,
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #initialization }
GtCoderNavigationProtocolsGroupedList >> buildProtocolItemWithOnClick: clickBlock [
	"An element that represents a protocol within a list of protocols"
	<return: #BlElement>
	| aLabelAptitude |
	aLabelAptitude := BrGlamorousLabelAptitude new
			padding: (BlInsets
					top: 2
					bottom: 2
					left: 1
					right: 1);
			add: BrGlamorousListItemAptitude;
			add: (BrGlamorousWithContextMenuAptitude
					content: [ :aWidget | GtCoderNavigationContextMenuContent new
							items: (self protocolListContextMenuItemsFor: (aWidget userData at: #protocol)) ]).

	^ BrLabel new
		hMatchParent;
		vFitContent;
		beSmallSize;
		aptitude: aLabelAptitude;
		when: BlClickEvent do: clickBlock;
		addEventHandler: self createProtocolDropHandler
]
