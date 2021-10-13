Class {
	#name : #GtMethodProtocolCompletionStrategy,
	#superclass : #GtStringsCompletionStrategy,
	#category : 'GToolkit-Coder-Completion'
}

{ #category : #private }
GtMethodProtocolCompletionStrategy >> buildCompletions [
	| protocols |
	protocols := GtPrefixTree new.
	Smalltalk globals
		allBehaviorsDo: [ :cls | protocols addAll: cls organization categories ].
	RPackage organizer packages
		do: [ :each | protocols add: '*' , each name ].
	^ protocols
]

{ #category : #accessing }
GtMethodProtocolCompletionStrategy >> completionPrefixAt: anIndex in: blText [
	anIndex < self minimumPrefixLength
		ifTrue: [ ^ nil ].
	^ (blText copyFrom: 1 to: anIndex) asString
]
