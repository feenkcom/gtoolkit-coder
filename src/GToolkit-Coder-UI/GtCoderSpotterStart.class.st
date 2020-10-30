Class {
	#name : #GtCoderSpotterStart,
	#superclass : #Object,
	#instVars : [
		'navigationModelBlock'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterForClassMethodsInCurrentClassFor: aStep [
	<gtSearch>
	self navigationModel hasSelectedClass
		ifFalse: [ ^ self ].
	aStep listProcessor
		priority: 2;
		title: 'Class methods';
		allCandidates: [ self navigationModel selectedClass classSide methods ];
		filter: GtFilterSubstring;
		wantsToDisplayOnEmptyQuery: true
]

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterForClassesFor: aStep [
	<gtSearch>
	aStep listProcessor
		priority: 10;
		allCandidates: [ Smalltalk allClassesAndTraits ];
		title: 'Classes';
		filter: GtFilterSubstring;
		itemIcon: #systemIcon;
		keyBinding: $b meta;
		wantsToDisplayOnEmptyQuery: self navigationModel hasSelectedClass not
]

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterForInstanceMethodsInCurrentClassFor: aStep [
	<gtSearch>
	self navigationModel hasSelectedClass
		ifFalse: [ ^ self ].
	aStep listProcessor
		priority: 1;
		title: 'Instance methods';
		allCandidates: [ self navigationModel selectedClass instanceSide methods ];
		filter: GtFilterSubstring;
		wantsToDisplayOnEmptyQuery: true
]

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterForMessagesFor: aStep [
	<gtSearch>
	aStep listProcessor
		priority: 35;
		title: 'Messages';
		filter: GtNullFilter
			item:
				[ :filter :context | GTSelector substring: context textTrimmed filter: filter ];
		actLogic: [ :each :step :spotterElement | 
			(each name asSymbol gtImplementors)
				gtSpotterActDefault: step
				from: spotterElement ];
		wantsToDisplayOnEmptyQuery: false
]

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterForPackagesFor: aStep [
	<gtSearch>
	aStep listProcessor
		priority: 20;
		allCandidates: [ RPackageOrganizer default packages ];
		title: 'Packages';
		itemName: [ :package | package name ];
		itemIcon: [ Smalltalk ui icons iconNamed: #packageIcon ];
		filter: GtFilterSubstring;
		wantsToDisplayOnEmptyQuery: self navigationModel hasSelectedPackage not
]

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterImplementorsFor: aStep [
	<gtSearch>
	self flag: #specialFilter.
	aStep listProcessor
		priority: 30;
		title: 'Implementors';
		filter: GtFilterImplementor
			item: [ :filter :context | 
			SystemNavigation default
				allBehaviorsDo: [ :class | class localMethods do: filter ] ];
		keyBinding: $m meta;
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
