Class {
	#name : #GtFilterExcludingFocusFinder,
	#superclass : #BlFocusFinder,
	#instVars : [
		'excludedElement'
	],
	#category : 'GToolkit-Coder-UI-Filters - Support'
}

{ #category : #accessing }
GtFilterExcludingFocusFinder >> excludedElement [
	^ excludedElement
]

{ #category : #accessing }
GtFilterExcludingFocusFinder >> excludedElement: anObject [
	excludedElement := anObject
]

{ #category : #'api - finder' }
GtFilterExcludingFocusFinder >> focusableCandidates [
	| theFocusCandidates someFocusCandidates |
	theFocusCandidates := BlFocusFinderCandidates new.
	someFocusCandidates := super focusableCandidates.
	someFocusCandidates
		do: [ :eachCandidate | 
			| toExclude |
			toExclude := false.
			eachCandidate == excludedElement
				ifTrue: [ eachCandidate isFocused ifFalse: [ toExclude := true ] ]
				ifFalse: [ eachCandidate allParentsDo: [ :eachParent | 
					eachParent == excludedElement 
						ifTrue: [ toExclude := true ] ] ].
			toExclude ifFalse: [ theFocusCandidates add: eachCandidate ] ].
	^ theFocusCandidates
]
