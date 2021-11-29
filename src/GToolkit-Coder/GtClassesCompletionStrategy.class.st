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
GtClassesCompletionStrategy >> completionActionStreamFor: aText at: positionInteger [
	| currentInput |
	currentInput := aText asString.
	currentInput isEmpty ifTrue: [ ^ #() ].
	^ (self candidateClasses asyncStreamStartingWith: currentInput)
		collect:
			[ :className | 
			| deletion insertion |
			deletion := positionInteger < currentInput size
				ifTrue:
					[ GtDeleteTextCompletionAction
						labeled: className
						from: positionInteger + 1
						to: currentInput size ].
			insertion := GtInsertTextCompletionAction
				labeled: className
				completion: (className allButFirst: positionInteger)
				position: positionInteger
				from: 1.
			deletion notNil
				ifTrue:
					[ (GtCompositeCompletionAction labeled: className)
						addAction: deletion;
						addAction: insertion;
						yourself ]
				ifFalse: [ insertion ] ]
]

{ #category : #accessing }
GtClassesCompletionStrategy >> completionActionsFor: aText at: positionInteger max: maxInteger [
	^ ((self completionActionStreamFor: aText at: positionInteger) take: maxInteger) toArray wait
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
