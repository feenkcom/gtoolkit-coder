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
GtMethodCoderRequester >> editor [
	"Hack to handle inserting local variables"

	^ self
]

{ #category : #binding }
GtMethodCoderRequester >> hasBindingOf: aSymbol [
	^ self bindingStrategy isNil
		ifTrue: [ super hasBindingOf: aSymbol ]
		ifFalse: [ bindingStrategy hasBindingOf: aSymbol ]

]

{ #category : #requester }
GtMethodCoderRequester >> notify: message at: anIndex in: aString [
	| index |
	index := (anIndex max: 1) min: coder sourceEditor text size.
	(coder sourceEditor text from: index to: index) attributes: {(GtMethodCoderErrorAttribute for: message)}.
	coder sourceEditor
		invalidate: index to: index;
		update: index to: index.
	coder sourceEditor moveCursorTo: index
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
