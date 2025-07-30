Class {
	#name : #GtCoderFilterList,
	#superclass : #BrSimpleList,
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #initialization }
GtCoderFilterList >> initialize [
	super initialize.
	self
		itemStencil: [ GtCoderFilterListItemElement new
			padding: (BlInsets all: 5);
			hMatchParent;
			vFitContent ];
		itemDataBinder: [ :anItemElement :anItemObject :anItemIndex |
			anItemElement item: anItemObject ].
		
	self 
		when: BrSelectionChanged 
		do: [ :anEvent | self onSelectionChanged: anEvent ].
		
	self vFitContent.
]

{ #category : #'api - accessing' }
GtCoderFilterList >> items: anItemCollection title: aTitleBlock action: anActionBlock [
	| anActionCollection |
	anActionCollection := anItemCollection collect: [ :eachItem | 
		GtCoderFilterListItem new
			item: eachItem;
			title: aTitleBlock;
			action: anActionBlock ].
	self items: anActionCollection.
]

{ #category : #'private - event handling' }
GtCoderFilterList >> onSelectionChanged: anEvent [
	self selectedItemDo: [ :anItem | 
		anEvent consumed: true.
		anItem actOnEvent: anEvent.
		self fireEvent: BrDropdownHideWish new. ]
]
