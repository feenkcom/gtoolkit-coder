Class {
	#name : #GtSourceCoderRequester,
	#superclass : #Object,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtSourceCoderRequester class >> on: aCoder editor: aBrTextEditor [
	^ self new
		coder: aCoder editor: aBrTextEditor;
		yourself
]

{ #category : #accessing }
GtSourceCoderRequester >> coder [
	^ coder
]

{ #category : #accessing }
GtSourceCoderRequester >> coder: anObject [
	coder := anObject
]

{ #category : #hack }
GtSourceCoderRequester >> editor [
	"Hack to handle inserting local variables"

	^ self
]

{ #category : #requester }
GtSourceCoderRequester >> notify: message at: anIndex in: aString [
]

{ #category : #requester }
GtSourceCoderRequester >> text [
	^ coder currentSourceString
]

{ #category : #hack }
GtSourceCoderRequester >> textMorph [
	"Hack to handle inserting local variables"

	^ self
]
