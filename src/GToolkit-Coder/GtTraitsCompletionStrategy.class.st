Class {
	#name : #GtTraitsCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#instVars : [
		'candidateTraits'
	],
	#category : #'GToolkit-Coder-Completion'
}

{ #category : #accessing }
GtTraitsCompletionStrategy >> candidateTraits [
	^  candidateTraits ifNil: [ 
			| theInterestingTraitNames |
			theInterestingTraitNames := Smalltalk allTraits collect: [ :eachTrait | eachTrait name ].
			candidateTraits := GtPrefixTree withAll: theInterestingTraitNames ]
]

{ #category : #accessing }
GtTraitsCompletionStrategy >> completionActionsFor: aText at: positionInteger max: maxInteger [
	| currentInput completionActions |

	currentInput := aText asString.
	completionActions := (self candidateTraits first: maxInteger startingWith: currentInput) collect: [ :traitName | 
		GtInsertTextCompletionAction
			labeled: traitName
			completion: (traitName allButFirst: currentInput size)
			position: positionInteger
			from: positionInteger - currentInput size + 1 ].

	^ completionActions
]

{ #category : #testing }
GtTraitsCompletionStrategy >> hasCompletionEntryFor: aString [
	^ true
]

{ #category : #testing }
GtTraitsCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]
