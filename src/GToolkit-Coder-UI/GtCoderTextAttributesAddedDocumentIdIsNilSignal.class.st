Class {
	#name : #GtCoderTextAttributesAddedDocumentIdIsNilSignal,
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
GtCoderTextAttributesAddedDocumentIdIsNilSignal >> coderTextAttributes [
	^ coderTextAttributes
]

{ #category : #accessing }
GtCoderTextAttributesAddedDocumentIdIsNilSignal >> coderTextAttributes: aGtTextualCoderTextAttributes [
	coderTextAttributes := aGtTextualCoderTextAttributes
]

{ #category : #accessing }
GtCoderTextAttributesAddedDocumentIdIsNilSignal >> editorElement [
	^ editorElement
]

{ #category : #accessing }
GtCoderTextAttributesAddedDocumentIdIsNilSignal >> editorElement: anObject [
	editorElement := anObject
]

{ #category : #accessing }
GtCoderTextAttributesAddedDocumentIdIsNilSignal >> endPosition [
	^ endPosition
]

{ #category : #accessing }
GtCoderTextAttributesAddedDocumentIdIsNilSignal >> endPosition: anObject [
	endPosition := anObject
]

{ #category : #views }
GtCoderTextAttributesAddedDocumentIdIsNilSignal >> gtTextAttributesViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Attributes';
		priority: 0;
		items: [ self textAttributes ifNil: [ #() ] ];
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Attribute' text: [ :each | each gtDisplayString ]
]

{ #category : #printing }
GtCoderTextAttributesAddedDocumentIdIsNilSignal >> printOneLineContentsOn: aStream [
	aStream
		nextPut: $[;
		print: startPosition;
		nextPut: $,;
		print: endPosition;
		nextPut: $];
		space;
		print: self textAttributes
]

{ #category : #accessing }
GtCoderTextAttributesAddedDocumentIdIsNilSignal >> startPosition [
	^ startPosition
]

{ #category : #accessing }
GtCoderTextAttributesAddedDocumentIdIsNilSignal >> startPosition: anObject [
	startPosition := anObject
]

{ #category : #accessing }
GtCoderTextAttributesAddedDocumentIdIsNilSignal >> textAttributes [
	^ coderTextAttributes ifNotNil: #textAttributes
]
