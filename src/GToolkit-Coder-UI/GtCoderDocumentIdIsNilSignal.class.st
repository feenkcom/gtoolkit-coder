Class {
	#name : #GtCoderDocumentIdIsNilSignal,
	#superclass : #GtCoderDocumentIdSignal,
	#instVars : [
		'originalDocumentId'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

{ #category : #'api - text' }
GtCoderDocumentIdIsNilSignal >> originalDocumentId: aDocumentId [
	originalDocumentId := aDocumentId
]

{ #category : #printing }
GtCoderDocumentIdIsNilSignal >> printOneLineContentsOn: aStream [
	aStream
		nextPutAll: 'Original: ';
		print: originalDocumentId
]
