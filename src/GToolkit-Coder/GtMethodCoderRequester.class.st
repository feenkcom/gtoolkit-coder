Class {
	#name : #GtMethodCoderRequester,
	#superclass : #Object,
	#instVars : [
		'coder',
		'bindingStrategy'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtMethodCoderRequester class >> on: aMethodCoder [
	^ self new
		coder: aMethodCoder;
		yourself
]

{ #category : #requester }
GtMethodCoderRequester >> bindingOf: aSymbol [
	^ bindingStrategy isNil
		ifTrue: [ super bindingOf: aSymbol ]
		ifFalse: [ bindingStrategy bindingOf: aSymbol ]
]

{ #category : #accessing }
GtMethodCoderRequester >> bindingStrategy [
	^ bindingStrategy
]

{ #category : #accessing }
GtMethodCoderRequester >> bindingStrategy: anObject [
	bindingStrategy := anObject
]

{ #category : #accessing }
GtMethodCoderRequester >> coder: aCoder [
	coder := aCoder
]

{ #category : #requester }
GtMethodCoderRequester >> correctFrom: fromIndex to: toIndex with: aString [
	| start offset |
	offset := self offset.
	start := fromIndex - offset.
	fromIndex > toIndex
		ifFalse: [ coder sourceEditor deleter
				from: start to: toIndex - offset + 1;
				delete ].
	coder sourceEditor inserter
		withoutSelectionDelete;
		at: start;
		text: aString;
		insert
]

{ #category : #hack }
GtMethodCoderRequester >> editor [
	"Hack to handle inserting local variables"

	^ self
]

{ #category : #requester }
GtMethodCoderRequester >> notify: message at: anIndex in: aString [
	| index editor |
	anIndex <= coder patternSource size
		ifTrue: [ index := anIndex - 1.
			editor := coder patternEditor ]
		ifFalse: [ index := anIndex - self offset.
			editor := coder sourceEditor ].
	index := index max: 1.
	(editor text from: index to: index) attributes: {(GtMethodCoderErrorAttribute for: message)}.
	editor
		invalidate: index to: index;
		update: index to: index.
	editor moveCursorTo: index
]

{ #category : #private }
GtMethodCoderRequester >> offset [
	^ coder patternSource size + 2
]

{ #category : #hack }
GtMethodCoderRequester >> paragraph [
	"Hack to handle inserting local variables"

	^ self
]

{ #category : #requester }
GtMethodCoderRequester >> text [
	^ coder newMethodSource
]

{ #category : #hack }
GtMethodCoderRequester >> textMorph [
	"Hack to handle inserting local variables"

	^ self
]
