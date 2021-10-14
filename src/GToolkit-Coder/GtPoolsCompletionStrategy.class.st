Class {
	#name : #GtPoolsCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#instVars : [
		'candidatePools'
	],
	#category : 'GToolkit-Coder-Completion'
}

{ #category : #accessing }
GtPoolsCompletionStrategy >> candidatePools [
	^  candidatePools ifNil: [ 
			| theInterestingPoolNames |
			theInterestingPoolNames := Smalltalk allClasses
				select: [ :eachClass | eachClass isPool ]
				thenCollect: [ :eachPool | eachPool name ].
			candidatePools := GtPrefixTree withAll: theInterestingPoolNames ]
]

{ #category : #accessing }
GtPoolsCompletionStrategy >> completionActionsFor: aText at: positionInteger max: maxInteger [
	| currentInput completionActions |

	currentInput := aText asString.
	completionActions := (self candidatePools first: maxInteger startingWith: currentInput) collect: [ :poolName | 
		GtInsertTextCompletionAction
			labeled: poolName
			completion: (poolName allButFirst: currentInput size)
			position: positionInteger
			from: positionInteger - currentInput size + 1 ].

	^ completionActions
]

{ #category : #testing }
GtPoolsCompletionStrategy >> hasCompletionEntryFor: aString [
	^ true
]

{ #category : #testing }
GtPoolsCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]
