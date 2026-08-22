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

{ #category : #accessing }
GtSearchFilterCreationCode >> searchFilter [
	^ searchFilter
]

{ #category : #accessing }
GtSearchFilterCreationCode >> searchFilter: anObject [
	searchFilter := anObject
]
