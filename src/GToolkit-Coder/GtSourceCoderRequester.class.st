Class {
	#name : #GtSourceCoderRequester,
	#superclass : #Object,
	#instVars : [
		'coder',
		'bindingStrategy'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtSourceCoderRequester class >> on: aCoder [
	^ self new
		coder: aCoder;
		yourself
]

{ #category : #requester }
GtSourceCoderRequester >> bindingOf: aSymbol [
	^ bindingStrategy isNil
		ifTrue: [ super bindingOf: aSymbol ]
		ifFalse: [ bindingStrategy bindingOf: aSymbol ]
]

{ #category : #accessing }
GtSourceCoderRequester >> bindingStrategy [
	^ bindingStrategy
]

{ #category : #accessing }
GtSourceCoderRequester >> bindingStrategy: anObject [
	bindingStrategy := anObject
]

{ #category : #accessing }
GtSourceCoderRequester >> coder: aCoder [
	coder := aCoder
]

{ #category : #requester }
GtSourceCoderRequester >> correctFrom: fromIndex to: toIndex with: aString [
	fromIndex > toIndex
		ifFalse: [ coder sourceEditor deleter
				from: fromIndex - 1 to: toIndex;
				delete ].
	coder sourceEditor inserter
		withoutSelectionDelete;
		at: fromIndex - 1;
		text: aString;
		insert
]

{ #category : #hack }
GtSourceCoderRequester >> editor [
	"Hack to handle inserting local variables"

	^ self
]

{ #category : #binding }
GtSourceCoderRequester >> hasBindingOf: aSymbol [
	^ self bindingStrategy isNil
		ifTrue: [ super hasBindingOf: aSymbol ]
		ifFalse: [ bindingStrategy hasBindingOf: aSymbol ]

]

{ #category : #requester }
GtSourceCoderRequester >> notify: message at: anIndex in: aString [
	| index |
	index := (anIndex max: 1) min: coder sourceEditor text size.
	(coder sourceEditor text from: index to: index) attributes: {(GtSourceCoderErrorAttribute for: message)}.
	coder sourceEditor
		invalidate: index to: index;
		update: index to: index.
	coder sourceEditor moveCursorTo: index
]

{ #category : #hack }
GtSourceCoderRequester >> paragraph [
	"Hack to handle inserting local variables"

	^ self
]

{ #category : #requester }
GtSourceCoderRequester >> text [
	^ coder newMethodSource
]

{ #category : #hack }
GtSourceCoderRequester >> textMorph [
	"Hack to handle inserting local variables"

	^ self
]
