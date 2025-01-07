Class {
	#name : #GtCharacterGroupDiffSplitter,
	#superclass : #GtDiffSplitter,
	#instVars : [
		'groups',
		'shouldIgnoreWhitespace'
	],
	#category : #'GToolkit-Coder-Diff-Algorithm'
}

{ #category : #'instance creation' }
GtCharacterGroupDiffSplitter class >> words [
	^ self new
		addGroup: #tokenish;
		addGroup: #isSeparator;
		yourself
]

{ #category : #adding }
GtCharacterGroupDiffSplitter >> addGroup: aSymbolOrBlock [
	groups add: aSymbolOrBlock
]

{ #category : #accessing }
GtCharacterGroupDiffSplitter >> classify: aCharacter [
	(shouldIgnoreWhitespace and: [ aCharacter isSeparator ]) ifTrue: [ ^ 0 ].
	^ (1 to: groups size)
		detect: [ :i | (groups at: i) value: aCharacter ]
		ifNone: [ groups size + 1 ]
]

{ #category : #'as yet unclassified' }
GtCharacterGroupDiffSplitter >> descriptionString [
	^ 'split by character groups (' , (', ' join: groups) , ')'
]

{ #category : #initialization }
GtCharacterGroupDiffSplitter >> ignoreWhitespace [
	shouldIgnoreWhitespace := true
]

{ #category : #initialization }
GtCharacterGroupDiffSplitter >> includeWhitespace [
	shouldIgnoreWhitespace := false
]

{ #category : #initialization }
GtCharacterGroupDiffSplitter >> initialize [
	super initialize.
	shouldIgnoreWhitespace := false.
	groups := OrderedCollection new
]

{ #category : #'as yet unclassified' }
GtCharacterGroupDiffSplitter >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: (', ' join: groups);
		nextPut: $)
]

{ #category : #accessing }
GtCharacterGroupDiffSplitter >> split: aString into: aGtDiffSplits [
	| stream start groupId nextGroupId |
	stream := aString readStream.
	groupId := 0.
	start := 1.
	[ stream atEnd ]
		whileFalse: [ nextGroupId := self classify: stream next.
			nextGroupId ~= groupId
				ifTrue: [ groupId = 0
						ifFalse: [ aGtDiffSplits
								addSplit: (GtRangeDiffSplit
										on: aString
										from: start
										to: stream position - 1) ].
					start := stream position.
					groupId := nextGroupId ] ].
	groupId > 0
		ifTrue: [ aGtDiffSplits
				addSplit: (GtRangeDiffSplit
						on: aString
						from: start
						to: stream position) ]
]
