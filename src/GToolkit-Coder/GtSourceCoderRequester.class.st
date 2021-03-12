Class {
	#name : #GtSourceCoderRequester,
	#superclass : #Object,
	#instVars : [
		'coder',
		'requesterObject'
	],
	#category : #'GToolkit-Coder-Coders'
}

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

{ #category : #accessing }
GtSourceCoderRequester >> requesterObject [
	^ requesterObject
]

{ #category : #accessing }
GtSourceCoderRequester >> requesterObject: anObject [
	requesterObject := anObject
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
