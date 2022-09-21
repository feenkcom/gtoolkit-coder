Class {
	#name : #GtCoderSpotterStart,
	#superclass : #Object,
	#instVars : [
		'navigationModelBlock'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterForClassMethodsInCurrentClassFor: aSearch [
	<gtSearch>
	self navigationModel hasSelectedClass ifFalse: [ ^ aSearch empty ].
	^ aSearch list
		priority: 2;
		title: 'Class methods';
		items: [ self navigationModel selectedClass classSide methods ];
		filterBySubstring;
		wantsToDisplayOnEmptyQuery: true
]

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterForClassesFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 10;
		items: [ Smalltalk allClassesAndTraits ];
		title: 'Classes';
		filterBySubstring;
		wantsToDisplayOnEmptyQuery: self navigationModel hasSelectedClass not
]

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterForInstanceMethodsInCurrentClassFor: aSearch [
	<gtSearch>
	self navigationModel hasSelectedClass ifFalse: [ ^ aSearch empty ].
	^ aSearch list
		priority: 1;
		title: 'Instance methods';
		items: [ self navigationModel selectedClass instanceSide methods ];
		filterBySubstring;
		wantsToDisplayOnEmptyQuery: true
]

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterForMessagesFor: aStep [
	<gtSearch>
	
	^ aStep list
		priority: 35;
		title: 'Messages';
		filter: GtNullFilter
			item:
				[ :filter :context | GtSelector substring: context textTrimmed filter: filter ];
		itemActLogic: [ :each :step :spotterElement | 
			(each name asSymbol gtImplementors)
				gtSpotterActDefault: step
				from: spotterElement ];
		wantsToDisplayOnEmptyQuery: false
]

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterForPackagesFor: aSearch [
	<gtSearch>
	^ aSearch list
		priority: 20;
		items: [ RPackageOrganizer default packages ];
		title: 'Packages';
		itemName: [ :package | package name ];
		filterBySubstring;
		wantsToDisplayOnEmptyQuery: self navigationModel hasSelectedPackage not
]

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterImplementorsFor: aStep [
	<gtSearch>
	^ aStep list
		priority: 30;
		title: 'Implementors';
		filter: GtFilterImplementor
			item: [ :filter :context | 
			SystemNavigation default
				allBehaviorsDo: [ :class | class localMethods do: filter ] ];
		"keyBinding: $m meta;"
		wantsToDisplayOnEmptyQuery: false
]

{ #category : #accessing }
GtCoderSpotterStart >> navigationModel [
	^ navigationModelBlock value
]

{ #category : #accessing }
GtCoderSpotterStart >> navigationModelBlock: aBlock [
	navigationModelBlock := aBlock
]

{ #category : #printing }
GtCoderSpotterStart >> printOn: aStream [
	aStream nextPutAll: 'Spotter'
]
