Class {
	#name : #GtCoderSpotterStart,
	#superclass : #Object,
	#instVars : [
		'navigationModelBlock'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

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
