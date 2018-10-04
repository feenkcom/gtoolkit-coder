Class {
	#name : #GtPackageClassesCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#instVars : [
		'packageSearchString'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtPackageClassesCompletionStrategy >> classesMatching: aString [
	| pattern classes |
	classes := Set new.
	pattern := '*' , aString , '*'.
	(GtPackagesCompletionStrategy findPackagesMatching: packageSearchString) do: [ :each | classes addAll: each classes ].
	(GtPackagesCompletionStrategy findPackageTagsMatching: packageSearchString) do: [ :each | classes addAll: each classes ].
	^ classes select: [ :each | pattern match: each name ]
]

{ #category : #accessing }
GtPackageClassesCompletionStrategy >> completionActionsFor: aText at: positionInteger max: maxInteger [
	| string |
	string := aText asString.
	^ ((self classesMatching: string) collect: [ :each | GtReplaceTextCompletionAction forText: each name ])
		asSortedCollection: [ :a :b | a text < b text ]
]

{ #category : #testing }
GtPackageClassesCompletionStrategy >> hasCompletionEntryFor: aString [
	^ true
]

{ #category : #testing }
GtPackageClassesCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]

{ #category : #'initialize-release' }
GtPackageClassesCompletionStrategy >> initialize [
	super initialize.
	packageSearchString := ''
]

{ #category : #accessing }
GtPackageClassesCompletionStrategy >> packageSearchString [
	^ packageSearchString
]

{ #category : #accessing }
GtPackageClassesCompletionStrategy >> packageSearchString: anObject [
	packageSearchString := anObject
]
