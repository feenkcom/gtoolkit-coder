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
	"Show both document ids, labelled by where they come from.

	They must not be compared. The styled text's id is assigned by the rust side, while the AST's is a
	Pharo side id from the same counter as ${class:BlText}$ document ids: in a recorded run the AST id sits
	one below the id of the BlText the editor was given, while the text id matches the editor's styling
	request. Both print as `DocumentId`, so the labels are the only thing keeping them apart."
	aStream
		nextPutAll: 'Ast styling starting, rust text ';
		nextPutAll: styledTextDocumentId printString;
		nextPutAll: ' size ';
		print: (styledText ifNotNil: [ :aText | aText size ]);
		nextPutAll: ', pharo ast ';
		nextPutAll: coderAstDocumentId printString;
		space
]
