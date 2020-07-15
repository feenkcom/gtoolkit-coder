Class {
	#name : #GtSourceCoderRequester,
	#superclass : #Object,
	#instVars : [
		'coder',
		'sourceCodeEditor',
		'bindingStrategy'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtSourceCoderRequester class >> on: aCoder editor: aBrTextEditor [
	^ self new
		coder: aCoder editor: aBrTextEditor;
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
	self halt.
]

{ #category : #accessing }
GtSourceCoderRequester >> coder: aCoder editor: aBrTextEditor [
	coder := aCoder.
	sourceCodeEditor := aBrTextEditor
]

{ #category : #requester }
GtSourceCoderRequester >> correctFrom: fromIndex to: toIndex with: aString [
	fromIndex > toIndex
		ifFalse: [ self sourceCodeEditor deleter
				from: fromIndex - 1 to: toIndex;
				delete ].
	self sourceCodeEditor inserter
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
	index := (anIndex max: 1) min: self sourceCodeEditor text size.
	(self sourceCodeEditor text from: index to: index)
		attributes: {(GtSourceCoderErrorAttribute for: message)}.
	self sourceCodeEditor moveCursorTo: index
]

{ #category : #hack }
GtSourceCoderRequester >> paragraph [
	"Hack to handle inserting local variables"

	^ self
]

{ #category : #accessing }
GtSourceCoderRequester >> sourceCodeEditor [
	<return: #BrTextEditor>

	^ sourceCodeEditor
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
