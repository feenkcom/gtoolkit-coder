Class {
	#name : #GtSourceCoderBasicEvaluationRequester,
	#superclass : #GtSourceCoderRequester,
	#instVars : [
		'sourceCodeEditor',
		'bindingStrategy'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtSourceCoderBasicEvaluationRequester class >> on: aCoder editor: aBrTextEditor [
	^ self new
		coder: aCoder editor: aBrTextEditor;
		yourself
]

{ #category : #requester }
GtSourceCoderBasicEvaluationRequester >> bindingOf: aSymbol [
	^ bindingStrategy isNil
		ifTrue: [ super bindingOf: aSymbol ]
		ifFalse: [ bindingStrategy bindingOf: aSymbol ]
]

{ #category : #accessing }
GtSourceCoderBasicEvaluationRequester >> bindingStrategy [
	^ bindingStrategy
]

{ #category : #accessing }
GtSourceCoderBasicEvaluationRequester >> bindingStrategy: anObject [
	bindingStrategy := anObject
]

{ #category : #accessing }
GtSourceCoderBasicEvaluationRequester >> coder: aCoder editor: aBrTextEditor [
	coder := aCoder.
	sourceCodeEditor := aBrTextEditor
]

{ #category : #requester }
GtSourceCoderBasicEvaluationRequester >> correctFrom: fromIndex to: toIndex with: aString [
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

{ #category : #binding }
GtSourceCoderBasicEvaluationRequester >> hasBindingOf: aSymbol [
	^ self bindingStrategy isNil
		ifTrue: [ super hasBindingOf: aSymbol ]
		ifFalse: [ bindingStrategy hasBindingOf: aSymbol ]

]

{ #category : #requester }
GtSourceCoderBasicEvaluationRequester >> notify: message at: anIndex in: aString [
	| index |
	index := (anIndex max: 1) min: self sourceCodeEditor text size.
	(self sourceCodeEditor text from: index to: index)
		attributes: {(GtSourceCoderErrorAttribute for: message)}.
	self sourceCodeEditor moveCursorTo: index
]

{ #category : #hack }
GtSourceCoderBasicEvaluationRequester >> paragraph [
	"Hack to handle inserting local variables"

	^ self
]

{ #category : #accessing }
GtSourceCoderBasicEvaluationRequester >> sourceCodeEditor [
	<return: #BrTextEditor>

	^ sourceCodeEditor
]
