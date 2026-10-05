Class {
	#name : #GtCoderAstStylerStartingSignal,
	#superclass : #GtCoderAstStylerSignal,
	#instVars : [
		'coderAstDocumentId',
		'coderAst'
	],
	#category : #'GToolkit-Coder-Signals'
}

{ #category : #accessing }
GtCoderAstStylerStartingSignal >> coderAst [
	^ coderAst
]

{ #category : #accessing }
GtCoderAstStylerStartingSignal >> coderAst: anObject [
	coderAst := anObject
]

{ #category : #accessing }
GtCoderAstStylerStartingSignal >> coderAstDocumentId [
	^ coderAstDocumentId
]

{ #category : #accessing }
GtCoderAstStylerStartingSignal >> coderAstDocumentId: anObject [
	coderAstDocumentId := anObject
]

{ #category : #printing }
GtCoderAstStylerStartingSignal >> printOneLineContentsOn: aStream [
	aStream
		nextPutAll: 'Ast styling starting, text ';
		nextPutAll: styledTextDocumentId printString;
		nextPutAll: ' size ';
		print: (styledText ifNotNil: [ :aText | aText size ]);
		nextPutAll: ', ast ';
		nextPutAll: coderAstDocumentId printString;
		space
]
