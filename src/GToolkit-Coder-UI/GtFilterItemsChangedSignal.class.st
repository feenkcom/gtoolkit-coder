Class {
	#name : #GtFilterItemsChangedSignal,
	#superclass : #GtFilterSignal,
	#instVars : [
		'incomingItems',
		'previousItems'
	],
	#category : 'GToolkit-Coder-UI-Filters - Events'
}

{ #category : #'gt - extensions' }
GtFilterItemsChangedSignal >> gtIncomingItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Incoming items';
		priority: -1;
		items: [ self incomingItems  ];
		column: 'Name' text: #yourself weight: 4;
		column: 'Was used' text: [ :anItem | self previousItems identityIncludes: anItem ];
		column: 'Is similar' text: [ :anItem | self previousItems includes: anItem ]
]

{ #category : #'gt - extensions' }
GtFilterItemsChangedSignal >> gtPreviousItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Previous items';
		priority: 0;
		items: [ self previousItems  ];
		column: 'Name' text: #yourself weight: 4;
		column: 'Is reused' text: [ :anItem | self incomingItems identityIncludes: anItem ];
		column: 'Is similar' text: [ :anItem | self incomingItems includes: anItem ]
]

{ #category : #accessing }
GtFilterItemsChangedSignal >> incomingItems [
	^ incomingItems
]

{ #category : #accessing }
GtFilterItemsChangedSignal >> incomingItems: anObject [
	incomingItems := anObject
]

{ #category : #accessing }
GtFilterItemsChangedSignal >> previousItems [
	^ previousItems
]

{ #category : #accessing }
GtFilterItemsChangedSignal >> previousItems: anObject [
	previousItems := anObject
]
