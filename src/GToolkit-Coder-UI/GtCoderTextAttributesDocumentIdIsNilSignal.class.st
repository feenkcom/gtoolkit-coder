Class {
	#name : #GtCoderTextAttributesDocumentIdIsNilSignal,
	#superclass : #GtCoderDocumentIdSignal,
	#instVars : [
		'editorElement',
		'receivedText',
		'startPosition',
		'endPosition',
		'coderTextAttributes'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

{ #category : #accessing }
GtCoderTextAttributesDocumentIdIsNilSignal >> coderTextAttributes [
	^ coderTextAttributes
]

{ #category : #accessing }
GtCoderTextAttributesDocumentIdIsNilSignal >> coderTextAttributes: aGtTextualCoderTextAttributes [
	coderTextAttributes := aGtTextualCoderTextAttributes
]

{ #category : #accessing }
GtCoderTextAttributesDocumentIdIsNilSignal >> editorElement [
	^ editorElement
]

{ #category : #accessing }
GtCoderTextAttributesDocumentIdIsNilSignal >> editorElement: anObject [
	editorElement := anObject
]

{ #category : #accessing }
GtCoderTextAttributesDocumentIdIsNilSignal >> endPosition [
	^ endPosition
]

{ #category : #accessing }
GtCoderTextAttributesDocumentIdIsNilSignal >> endPosition: anObject [
	endPosition := anObject
]

{ #category : #printing }
GtCoderTextAttributesDocumentIdIsNilSignal >> printOneLineContentsOn: aStream [
	aStream
		nextPut: $[;
		print: startPosition;
		nextPut: $,;
		print: endPosition;
		space;
		print: self textAttributes
]

{ #category : #accessing }
GtCoderTextAttributesDocumentIdIsNilSignal >> receivedText [
	^ receivedText
]

{ #category : #accessing }
GtCoderTextAttributesDocumentIdIsNilSignal >> receivedText: anObject [
	receivedText := anObject
]

{ #category : #accessing }
GtCoderTextAttributesDocumentIdIsNilSignal >> startPosition [
	^ startPosition
]

{ #category : #accessing }
GtCoderTextAttributesDocumentIdIsNilSignal >> startPosition: anObject [
	startPosition := anObject
]

{ #category : #accessing }
GtCoderTextAttributesDocumentIdIsNilSignal >> textAttributes [
	^ coderTextAttributes ifNotNil: #textAttributes
]
