Class {
	#name : #GtSearchFilterCreationCode,
	#superclass : #Object,
	#instVars : [
		'codeString',
		'searchFilter',
		'codeBuilder'
	],
	#category : #'GToolkit-SearchFilters'
}

{ #category : #accessing }
GtSearchFilterCreationCode >> codeBuilder: anObject [ 
	codeBuilder := anObject 
]

{ #category : #accessing }
GtSearchFilterCreationCode >> codeString [
	^ codeString
]

{ #category : #accessing }
GtSearchFilterCreationCode >> codeString: anObject [
	codeString := anObject
]

{ #category : #views }
GtSearchFilterCreationCode >> gtViewFilterCreationCodeFor: aView [
	<gtView>
	^ aView forward
		title: 'Code';
		priority: 90;
		object: [ LePharoSnippet code: codeString ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtSearchFilterCreationCode >> searchFilter [
	^ searchFilter
]

{ #category : #accessing }
GtSearchFilterCreationCode >> searchFilter: anObject [
	searchFilter := anObject
]
