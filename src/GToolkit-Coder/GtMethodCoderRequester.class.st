Class {
	#name : #GtMethodCoderRequester,
	#superclass : #Object,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtMethodCoderRequester class >> on: aMethodCoder [
	^ self new
		coder: aMethodCoder;
		yourself
]

{ #category : #accessing }
GtMethodCoderRequester >> coder: anObject [
	coder := anObject
]

{ #category : #requester }
GtMethodCoderRequester >> correctFrom: fromIndex to: toIndex with: aString [
	| start offset |
	offset := coder patternSource size + 2.
	start := fromIndex - offset.
	coder textEditor deleter
		from: start to: toIndex - offset + 1;
		delete.
	coder textEditor inserter
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
	| index |
	index := anIndex - coder patternSource size - 2.
	(coder textEditor text from: index to: index) attributes: {(GtMethodCoderErrorAttribute for: message)}.
	coder textEditor
		invalidate: index to: index;
		update: index to: index.
	coder textEditor moveCursorTo: index
]

{ #category : #hack }
GtMethodCoderRequester >> paragraph [
	"Hack to handle inserting local variables"

	^ self
]

{ #category : #requester }
GtMethodCoderRequester >> text [
	^ coder methodSource
]

{ #category : #hack }
GtMethodCoderRequester >> textMorph [
	"Hack to handle inserting local variables"

	^ self
]
