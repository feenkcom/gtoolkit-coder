Class {
	#name : #GtCoderSpotterStart,
	#superclass : #Object,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterForClassesFor: aStep [
	<gtSearch>
	aStep listProcessor
		priority: 10;
		allCandidates: [ Smalltalk allClassesAndTraits ];
		title: 'Classes';
		filter: GTFilterSubstring;
		itemIcon: #systemIcon;
		keyBinding: $b meta;
		wantsToDisplayOnEmptyQuery: true
]

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterForMessagesFor: aStep [
	<gtSearch>
	aStep listProcessor
		priority: 35;
		title: 'Messages';
		filter: GTNullFilter
			item:
				[ :filter :context | GTSelector substring: context textTrimmed filter: filter ];
		actLogic: [ :each :step | 
			step exit.
			self systemNavigation browseAllImplementorsOf: each name ];
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
		filter: GTFilterSubstring;
		wantsToDisplayOnEmptyQuery: true
]

{ #category : #searching }
GtCoderSpotterStart >> gtSpotterImplementorsFor: aStep [
	<gtSearch>
	self flag: #specialFilter.
	aStep listProcessor
		priority: 30;
		title: 'Implementors';
		filter: GTFilterImplementor
			item: [ :filter :context | 
			SystemNavigation default
				allBehaviorsDo: [ :class | class localMethods do: filter ] ];
		keyBinding: $m meta;
		wantsToDisplayOnEmptyQuery: false
]

{ #category : #printing }
GtCoderSpotterStart >> printOn: aStream [
	aStream nextPutAll: 'Spotter'
]
