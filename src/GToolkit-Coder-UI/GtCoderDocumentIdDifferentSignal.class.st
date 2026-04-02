Class {
	#name : #GtCoderDocumentIdDifferentSignal,
	#superclass : #GtCoderDocumentIdSignal,
	#instVars : [
		'originalDocumentId',
		'receivedDocumentId'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

{ #category : #'api - text' }
GtCoderDocumentIdDifferentSignal >> originalDocumentId: aDocumentId [
	originalDocumentId := aDocumentId
]

{ #category : #printing }
GtCoderDocumentIdDifferentSignal >> printOneLineContentsOn: aStream [
	aStream
		nextPutAll: 'Original: ';
		print: originalDocumentId;
		nextPutAll: ', received: ';
		print: receivedDocumentId
]

{ #category : #'api - text' }
GtCoderDocumentIdDifferentSignal >> receivedDocumentId: aDocumentId [
	receivedDocumentId := aDocumentId
]
