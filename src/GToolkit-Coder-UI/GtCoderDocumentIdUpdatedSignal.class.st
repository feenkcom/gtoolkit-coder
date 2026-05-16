Class {
	#name : #GtCoderDocumentIdUpdatedSignal,
	#superclass : #GtCoderDocumentIdSignal,
	#instVars : [
		'texturalCoderViewModel',
		'oldDocumentId',
		'newDocumentId'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

{ #category : #accessing }
GtCoderDocumentIdUpdatedSignal >> newDocumentId [
	^ newDocumentId
]

{ #category : #accessing }
GtCoderDocumentIdUpdatedSignal >> newDocumentId: anObject [
	newDocumentId := anObject
]

{ #category : #accessing }
GtCoderDocumentIdUpdatedSignal >> oldDocumentId [
	^ oldDocumentId
]

{ #category : #accessing }
GtCoderDocumentIdUpdatedSignal >> oldDocumentId: anObject [
	oldDocumentId := anObject
]

{ #category : #printing }
GtCoderDocumentIdUpdatedSignal >> printOneLineContentsOn: aStream [
	aStream
		print: newDocumentId;
		nextPutAll: ', old is ';
		print: oldDocumentId
]

{ #category : #accessing }
GtCoderDocumentIdUpdatedSignal >> texturalCoderViewModel [
	^ texturalCoderViewModel
]

{ #category : #accessing }
GtCoderDocumentIdUpdatedSignal >> texturalCoderViewModel: anObject [
	texturalCoderViewModel := anObject
]
