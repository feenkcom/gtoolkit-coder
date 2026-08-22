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
	^ (self class compiler  parseScript:  self computeRawCreationCode) body  formattedCode
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

{ #category : #accessing }
GtSearchFilterCreationCodeBuilder >> searchFilter: aSearchFilter [
	searchFilter := aSearchFilter
]
