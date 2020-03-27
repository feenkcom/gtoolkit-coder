Class {
	#name : #GtCoderClassWithPackageCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#instVars : [
		'allPackages',
		'allClasses'
	],
	#category : #'GToolkit-Coder-Completion'
}

{ #category : #accessing }
GtCoderClassWithPackageCompletionStrategy >> allClasses [
	^  allClasses ifNil: [ 
			allClasses := GtPrefixTree withAll: Smalltalk globals classNames ]
]

{ #category : #accessing }
GtCoderClassWithPackageCompletionStrategy >> allPackages [
	^ allPackages ifNil: [ 
		allPackages := GtPrefixTree withAll: RPackage organizer packageNames ]
]

{ #category : #accessing }
GtCoderClassWithPackageCompletionStrategy >> classesIn: aPackage [
	^ GtPrefixTree withAll: aPackage definedClassNames 
]

{ #category : #accessing }
GtCoderClassWithPackageCompletionStrategy >> completionActionsFor: aText at: positionInteger max: maxInteger [
	| currentInput completionActions delimitedIndex |
	currentInput := aText asString.
	delimitedIndex := currentInput indexOf: $>.
	delimitedIndex > 0 ifTrue: [
		| extractedPackageName partialClassName package |
		extractedPackageName := currentInput copyFrom: 1 to: delimitedIndex - 1.
		partialClassName := currentInput copyFrom: delimitedIndex + 1 to: currentInput size.
		package := RPackage organizer 
			packageNamed: extractedPackageName 
			ifAbsent: [ ^ #() ].
		^ ((self classesIn: package) first: maxInteger startingWith: partialClassName) collect: [ :className |
				GtInsertTextCompletionAction
					labeled: className
					completion: (className allButFirst: partialClassName size) 
					position: positionInteger
					from: positionInteger - partialClassName size + 1 ] ].
	completionActions := (self allClasses first: (maxInteger/2) asInteger  startingWith: currentInput) collect: [ :className | 
		GtInsertTextCompletionAction
			labeled: className
			completion: (className allButFirst: currentInput size)
			position: positionInteger
			from: positionInteger - currentInput size + 1 ].
	completionActions addAll: ((self allPackages first: (maxInteger/2) asInteger startingWith: currentInput) collect: [ :packageName | 
		GtInsertTextCompletionAction
			labeled: packageName
			completion: (packageName allButFirst: currentInput size) , '>'
			position: positionInteger
			from: positionInteger - currentInput size + 1 ]).

	^ completionActions
	"(self class findPackageTagsMatching: completionString) do: [ :each | 
		completionActions add: (GtReplaceTextCompletionAction forText: each categoryName) ]."
	
]

{ #category : #testing }
GtCoderClassWithPackageCompletionStrategy >> hasCompletionEntryFor: aString [
	^ true
]

{ #category : #testing }
GtCoderClassWithPackageCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]
