Class {
	#name : #GtSearchFilterCreationCodeBuilder,
	#superclass : #Object,
	#instVars : [
		'searchFilter'
	],
	#category : #'GToolkit-SearchFilters'
}

{ #category : #'instance creation' }
GtSearchFilterCreationCodeBuilder class >> forSearchFilter: aSearchFilter [
	^ self new
			searchFilter: aSearchFilter
]

{ #category : #accessing }
GtSearchFilterCreationCodeBuilder >> computeFormattedCreationCode [
	^ (RBParser 
			parseExpression: self computeRawCreationCode) formattedCode
]

{ #category : #accessing }
GtSearchFilterCreationCodeBuilder >> computeRawCreationCode [
	^ String
		streamContents: [ :aStream | searchFilter storeCreationCodeOn: aStream ]
]

{ #category : #accessing }
GtSearchFilterCreationCodeBuilder >> creationCode [
	^ GtSearchFilterCreationCode new
		codeString: self computeFormattedCreationCode;
		searchFilter: searchFilter;
		codeBuilder: self
]

{ #category : #views }
GtSearchFilterCreationCodeBuilder >> gtViewFilterCreationCodeFor: aView [
	<gtView>
	^ aView forward
		title: 'Creation code';
		priority: 90;
		object: [ self creationCode ];
		view: #gtViewFilterCreationCodeFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect code builder' 
			action: [ :aButton |
				aButton phlow 
					spawnObject: (self creationCode) ]
]

{ #category : #accessing }
GtSearchFilterCreationCodeBuilder >> searchFilter: aSearchFilter [
	searchFilter := aSearchFilter
]
