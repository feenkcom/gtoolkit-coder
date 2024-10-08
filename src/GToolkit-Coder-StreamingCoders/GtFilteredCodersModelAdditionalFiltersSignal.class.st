Class {
	#name : #GtFilteredCodersModelAdditionalFiltersSignal,
	#superclass : #GtFilterSignal,
	#instVars : [
		'incomingAdditionalFilters',
		'existingAdditionalFilters',
		'usedAdditionalFilters'
	],
	#category : #'GToolkit-Coder-StreamingCoders-Signals'
}

{ #category : #accessing }
GtFilteredCodersModelAdditionalFiltersSignal >> existingAdditionalFilters [
	^ existingAdditionalFilters
]

{ #category : #accessing }
GtFilteredCodersModelAdditionalFiltersSignal >> existingAdditionalFilters: anObject [
	existingAdditionalFilters := anObject
]

{ #category : #'gt - extensions' }
GtFilteredCodersModelAdditionalFiltersSignal >> gtAdditionalFiltersFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Incoming filters';
		priority: -1;
		items: [ self incomingAdditionalFilters  ];
		column: 'Name' text: #yourself weight: 3;
		column: 'Is used' text: [ :aFilter | self usedAdditionalFilters identityIncludes: aFilter ];
		column: 'Previously used' text: [ :aFilter | self existingAdditionalFilters identityIncludes: aFilter ]
]

{ #category : #'gt - extensions' }
GtFilteredCodersModelAdditionalFiltersSignal >> gtUsedFiltersFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Used filters';
		priority: 0;
		items: [ self usedAdditionalFilters  ];
		column: 'Name' text: #yourself;
		column: 'Is incoming' text: [ :aFilter | self incomingAdditionalFilters identityIncludes: aFilter ]
]

{ #category : #accessing }
GtFilteredCodersModelAdditionalFiltersSignal >> incomingAdditionalFilters [
	^ incomingAdditionalFilters ifNil: [ #() ]
]

{ #category : #accessing }
GtFilteredCodersModelAdditionalFiltersSignal >> incomingAdditionalFilters: anObject [
	incomingAdditionalFilters := anObject
]

{ #category : #accessing }
GtFilteredCodersModelAdditionalFiltersSignal >> usedAdditionalFilters [
	^ usedAdditionalFilters ifNil: [ #() ]
]

{ #category : #accessing }
GtFilteredCodersModelAdditionalFiltersSignal >> usedAdditionalFilters: anObject [
	usedAdditionalFilters := anObject
]
