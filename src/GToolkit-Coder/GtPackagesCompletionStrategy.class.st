Class {
	#name : 'GtPackagesCompletionStrategy',
	#superclass : 'GtCompletionStrategy',
	#category : 'GToolkit-Coder-Completion'
}

{ #category : 'private' }
GtPackagesCompletionStrategy class >> allPackages [
	^ RPackageOrganizer default packages
]

{ #category : 'private' }
GtPackagesCompletionStrategy class >> allPackagesDo: aBlock [
	^ RPackageOrganizer default packagesDo: aBlock
]

{ #category : 'querying' }
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

{ #category : 'querying' }
GtPackagesCompletionStrategy class >> findPackagesMatching: aString [
	| searchString results |
	searchString := '*' , aString , '*'.
	results := OrderedCollection new.
	self allPackagesDo: [ :each | 
		(searchString match: each name)
			ifTrue: [ results add: each ] ].
	^ results
]

{ #category : 'accessing' }
GtPackagesCompletionStrategy >> completionActionsFor: aText at: positionInteger max: maxInteger [
	| string completionActions |
	string := aText asString.
	string isEmpty 
		ifTrue: [ ^#() ].
	completionActions := Set new.
	(self class findPackagesMatching: string) do: [ :each | 
		completionActions add: (GtReplaceTextCompletionAction forText: each name) ].
	(self class findPackageTagsMatching: string) do: [ :each | 
		completionActions add: (GtReplaceTextCompletionAction forText: each categoryName) ].
	^ completionActions asSortedCollection: [ :a :b | 
		a text < b text ]
]

{ #category : 'testing' }
GtPackagesCompletionStrategy >> hasCompletionEntryFor: aString [
	^ true
]

{ #category : 'testing' }
GtPackagesCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]
