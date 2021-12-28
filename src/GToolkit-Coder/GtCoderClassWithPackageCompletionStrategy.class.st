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
GtCoderClassWithPackageCompletionStrategy >> completionActionStreamFor: aText at: positionInteger [
	| currentInput delimitedIndex |
	currentInput := aText asString.
	delimitedIndex := currentInput indexOf: $>.
	delimitedIndex > 0
		ifTrue:
			[ | extractedPackageName partialClassName package |
			extractedPackageName := currentInput copyFrom: 1 to: delimitedIndex - 1.
			partialClassName := currentInput copyFrom: delimitedIndex + 1 to: currentInput size.
			package := RPackage organizer packageNamed: extractedPackageName ifAbsent: [ ^ #() ].
			^ ((self classesIn: package) asyncStreamStartingWith: partialClassName)
				collect:
					[ :className | 
					GtInsertTextCompletionAction
						labeled: (self labelFor: className withSearch: partialClassName)
						completion: (className allButFirst: partialClassName size)
						position: positionInteger
						from: positionInteger - partialClassName size + 1 ] ].
	^ ((self allClasses asyncStreamStartingWith: currentInput)
		collect:
			[ :className | 
			GtInsertTextCompletionAction
				labeled: (self labelFor: className withSearch: currentInput)
				completion: (className allButFirst: currentInput size)
				position: positionInteger
				from: positionInteger - currentInput size + 1 ])
		merge:
			((self allPackages asyncStreamStartingWith: currentInput)
				collect:
					[ :packageName | 
					GtInsertTextCompletionAction
						labeled: (self labelFor: packageName withSearch: currentInput)
						completion: (packageName allButFirst: currentInput size) , '>'
						position: positionInteger
						from: positionInteger - currentInput size + 1 ])
]

{ #category : #testing }
GtCoderClassWithPackageCompletionStrategy >> hasCompletionEntryFor: aString [
	^ true
]

{ #category : #testing }
GtCoderClassWithPackageCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]
