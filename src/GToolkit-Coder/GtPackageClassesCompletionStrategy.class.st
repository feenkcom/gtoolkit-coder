Class {
	#name : #GtPackageClassesCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#instVars : [
		'packageSearchString'
	],
	#category : #'GToolkit-Coder-Completion'
}

{ #category : #accessing }
GtPackageClassesCompletionStrategy >> classStreamMatching: aString [
	| classNamePattern matchedClasses |
	matchedClasses := Set new.
	classNamePattern := '*' , aString , '*'.
	^ (((GtPackagesCompletionStrategy packageAndTagStreamMatching: packageSearchString)
		collect: [ :each | each classes asAsyncStream ]) flatten select: [ :each | classNamePattern match: each name ])
		withoutDuplicates
]

{ #category : #accessing }
GtPackageClassesCompletionStrategy >> completionActionStreamFor: aText at: positionInteger [
	| string |
	string := aText asString.
	^ (self classStreamMatching: string) collect: [ :each | GtReplaceTextCompletionAction forText: each name ]
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
