Class {
	#name : #GtSearchCommentsFilter,
	#superclass : #GtSearchMethodsFilter,
	#instVars : [
		'text',
		'wholeWord',
		'caseSensitive'
	],
	#category : #'GToolkit-Coder-Filters'
}

{ #category : #comparing }
GtSearchCommentsFilter >> = anObject [
	^ self class = anObject class
		and: [ self text = anObject text
				and: [ self wholeWord = anObject wholeWord
						and: [ self caseSensitive = anObject caseSensitive ] ] ]
]

{ #category : #accessing }
GtSearchCommentsFilter >> caseSensitive [
	^ caseSensitive
]

{ #category : #accessing }
GtSearchCommentsFilter >> caseSensitive: aBoolean [
	caseSensitive := aBoolean
]

{ #category : #comparing }
GtSearchCommentsFilter >> hash [
	^ self class hash bitXor: self text hash
]

{ #category : #testing }
GtSearchCommentsFilter >> includesMethod: aCompiledMethod [
	| methodAst |
	(aCompiledMethod sourceCode
		findString: self text
		startingAt: 1
		caseSensitive: self caseSensitive) > 0
		ifFalse: [ ^ false ].
	self matchingIntervalsInMethod: aCompiledMethod do: [ :each | ^ true ].
	^ false
]

{ #category : #'initialize-release' }
GtSearchCommentsFilter >> initialize [
	super initialize.
	wholeWord := true.
	caseSensitive := true
]

{ #category : #'private - testing' }
GtSearchCommentsFilter >> isWordBoundaryCharacter: aCharacter [
	^ aCharacter isNil or: [ aCharacter isAlphaNumeric not ]
]

{ #category : #iterating }
GtSearchCommentsFilter >> matchingIntervalsInAST: methodAst do: aBlock [
	methodAst
		nodesDo: [ :node | 
			node comments
				do: [ :comment | 
					self
						matchingIntervalsInString: comment contents
						do: [ :interval | 
							aBlock
								value: (comment start + interval first to: comment start + interval last) ] ] ]
]

{ #category : #iterating }
GtSearchCommentsFilter >> matchingIntervalsInMethod: aCompiledMethod do: aBlock [
	| methodAst |
	methodAst := aCompiledMethod ast.
	self matchingIntervalsInAST: methodAst do: aBlock
]

{ #category : #private }
GtSearchCommentsFilter >> matchingIntervalsInString: aString do: aBlock [
	| sourceString searchString index |
	self caseSensitive
		ifTrue: [ sourceString := aString.
			searchString := self text ]
		ifFalse: [ sourceString := aString asLowercase.
			searchString := self text asLowercase ].
	index := 1.
	[ index <= sourceString size
		and: [ (index := sourceString
				indexOfSubCollection: searchString
				startingAt: index) > 0 ] ]
		whileTrue: [ (self wholeWord not
				or: [ (self
						isWordBoundaryCharacter: (sourceString at: index - 1 ifAbsent: [ nil ]))
						and: [ self
								isWordBoundaryCharacter: (sourceString at: index + searchString size ifAbsent: [ nil ]) ] ])
				ifTrue: [ aBlock value: (index to: index + searchString size - 1) ].
			index := index + searchString size ]
]

{ #category : #accessing }
GtSearchCommentsFilter >> text [
	^ text
]

{ #category : #accessing }
GtSearchCommentsFilter >> text: aString [
	text := aString
]

{ #category : #accessing }
GtSearchCommentsFilter >> wholeWord [
	^ wholeWord
]

{ #category : #accessing }
GtSearchCommentsFilter >> wholeWord: aBoolean [
	wholeWord := aBoolean
]
