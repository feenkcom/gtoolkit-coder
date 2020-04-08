Class {
	#name : #GtClassesCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#instVars : [
		'excludedClasses',
		'candidateClasses'
	],
	#category : #'GToolkit-Coder-Completion'
}

{ #category : #accessing }
GtClassesCompletionStrategy >> candidateClasses [
	^  candidateClasses ifNil: [ 
			| theInterestingClassNames |
			theInterestingClassNames := Smalltalk globals classNames copyWithoutAll: (excludedClasses collect: [ :eachClass | eachClass name ]).
			candidateClasses := GtPrefixTree withAll: theInterestingClassNames ]
]

{ #category : #accessing }
GtClassesCompletionStrategy >> completionActionsFor: aText at: positionInteger max: maxInteger [
	| currentInput completionActions |

	currentInput := aText asString.
	completionActions := (self candidateClasses first: maxInteger startingWith: currentInput) collect: [ :className | 
		GtInsertTextCompletionAction
			labeled: className
			completion: (className allButFirst: currentInput size)
			position: positionInteger
			from: positionInteger - currentInput size + 1 ].

	^ completionActions
]

{ #category : #initialization }
GtClassesCompletionStrategy >> excludeClasses: aCollectionOfClasses [
	excludedClasses := aCollectionOfClasses asSet
]

{ #category : #testing }
GtClassesCompletionStrategy >> hasCompletionEntryFor: aString [
	^ true
]

{ #category : #testing }
GtClassesCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]

{ #category : #initialization }
GtClassesCompletionStrategy >> initialize [
	super initialize.
	
	excludedClasses := Set new
]
