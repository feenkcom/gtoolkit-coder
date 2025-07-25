Class {
	#name : #GtPackagesCompletionStrategy,
	#superclass : #GtStreamedCompletionStrategy,
	#category : #'GToolkit-Coder-Completion'
}

{ #category : #private }
GtPackagesCompletionStrategy class >> allPackages [
	^ self packageOrganizer packages asSortedCollection: [ :a :b | a name < b name ]
]

{ #category : #private }
GtPackagesCompletionStrategy class >> allPackagesDo: aBlock [
	^ self packageOrganizer packagesDo: aBlock
]

{ #category : #querying }
GtPackagesCompletionStrategy class >> findPackageTagsMatching: aString [
	| searchString results |
	searchString := '*' , aString , '*'.
	results := OrderedCollection new.
	self allPackagesDo: [ :each | 
		each tags
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
GtPackagesCompletionStrategy >> completionActionStreamFor: aText at: positionInteger requested: aBoolean [
	| string searchString |
	string := aText asString.
	string isEmpty ifTrue: [ ^ #() ].
	searchString := '*' , string , '*'.
	^ ((self class packageStreamMatching: searchString)
		collect: [ :each | (each isPharoPackageModel) ifTrue: [ each name ] ifFalse: [ each categoryName ] ]) withoutDuplicates
		collect: [ :each | GtReplaceTextCompletionAction forText: each ]
]

{ #category : #testing }
GtPackagesCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]
