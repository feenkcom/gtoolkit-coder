Class {
	#name : #GtPackagesCompletionStrategy,
	#superclass : #GtStreamedCompletionStrategy,
	#category : #'GToolkit-Coder-Completion'
}

{ #category : #private }
GtPackagesCompletionStrategy class >> allPackages [
	^ RPackageOrganizer default packages asSortedCollection: [ :a :b | a name < b name ]
]

{ #category : #private }
GtPackagesCompletionStrategy class >> allPackagesDo: aBlock [
	^ RPackageOrganizer default packagesDo: aBlock
]

{ #category : #querying }
GtPackagesCompletionStrategy class >> findPackageTagsMatching: aString [
	| searchString results |
	searchString := '*' , aString , '*'.
	results := OrderedCollection new.
	self allPackagesDo: [ :each | 
		each classTags
			do: [ :tag | 
				(searchString match: tag categoryName)
					ifTrue: [ results add: tag ] ] ].
	^ results
]

{ #category : #querying }
GtPackagesCompletionStrategy class >> findPackagesMatching: aString [
	| searchString results |
	searchString := '*' , aString , '*'.
	results := OrderedCollection new.
	self allPackagesDo: [ :each | 
		(searchString match: each name)
			ifTrue: [ results add: each ] ].
	^ results
]

{ #category : #querying }
GtPackagesCompletionStrategy class >> packageStreamMatching: searchString [
	^ self allPackages asAsyncStream
		select:
			[ :each | 
			searchString match: each name]
]

{ #category : #accessing }
GtPackagesCompletionStrategy >> completionActionStreamFor: aText at: positionInteger [
	| string searchString |
	string := aText asString.
	string isEmpty ifTrue: [ ^ #() ].
	searchString := '*' , string , '*'.
	^ ((self class packageStreamMatching: searchString)
		collect: [ :each | (each isKindOf: RPackage) ifTrue: [ each name ] ifFalse: [ each categoryName ] ]) withoutDuplicates
		collect: [ :each | GtReplaceTextCompletionAction forText: each ]
]

{ #category : #testing }
GtPackagesCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]
