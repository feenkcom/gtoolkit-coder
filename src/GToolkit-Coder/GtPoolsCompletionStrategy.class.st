Class {
	#name : #GtPoolsCompletionStrategy,
	#superclass : #GtCompletionStrategy,
	#instVars : [
		'candidatePools'
	],
	#category : #'GToolkit-Coder-Completion'
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
GtPoolsCompletionStrategy >> completionActionStreamFor: aText at: positionInteger [
	| currentInput |
	currentInput := aText asString.
	^ (self candidatePools asyncStreamStartingWith: currentInput)
		collect:
			[ :poolName | 
			GtInsertTextCompletionAction
				labeled: (self labelFor: poolName withSearch: currentInput)
				completion: (poolName allButFirst: currentInput size)
				position: positionInteger
				from: positionInteger - currentInput size + 1 ]
]

{ #category : #testing }
GtPoolsCompletionStrategy >> hasCompletionEntryFor: aString [
	^ true
]

{ #category : #testing }
GtPoolsCompletionStrategy >> hasCompletionsAt: anInteger in: aText [
	^ true
]
