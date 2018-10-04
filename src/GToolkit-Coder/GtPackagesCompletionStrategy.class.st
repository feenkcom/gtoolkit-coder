Class {
	#name : #GtPackagesCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#category : #'GToolkit-Coder'
}

{ #category : #private }
GtPackagesCompletionStrategy class >> allPackages [
	^ RPackageOrganizer default packages
]

{ #category : #querying }
GtPackagesCompletionStrategy class >> findPackageTagsMatching: aString [
	| searchString results |
	searchString := '*' , aString , '*'.
	results := OrderedCollection new.
	self allPackages
		do: [ :each | 
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
	self allPackages
		do: [ :each | 
			(searchString match: each name)
				ifTrue: [ results add: each ].
			each classTags
				do: [ :tag | 
					(searchString match: tag name)
						ifTrue: [ results add: tag ] ] ].
	^ results
]

{ #category : #accessing }
GtPackagesCompletionStrategy >> completionActionsFor: aText at: positionInteger max: maxInteger [
	| string actions |
	string := aText asString.
	actions := Set new.
	(self class findPackagesMatching: string) do: [ :each | actions add: (GtReplaceTextCompletionAction forText: each name) ].
	(self class findPackageTagsMatching: string)
		do: [ :each | actions add: (GtReplaceTextCompletionAction forText: each categoryName) ].
	^ actions asSortedCollection: [ :a :b | a text < b text ]
]

{ #category : #testing }
GtPackagesCompletionStrategy >> hasCompletionEntryFor: aString [
	^ true
]

{ #category : #testing }
GtPackagesCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]
