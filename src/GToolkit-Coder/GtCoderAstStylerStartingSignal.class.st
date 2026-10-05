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
	"Show both document ids and the size of the text about to be styled.

	The ids are deliberately not labelled by provenance. When the coder is backed by the rust editor the
	text's id is assigned by the rust side while the AST's is a Pharo side one, so the two come from
	different counters and comparing them is meaningless; for any other coder both are Pharo side. This
	styler serves every Pharo coder, so it cannot know which case it is in, and a label claiming one would
	be wrong half the time."
	aStream
		nextPutAll: 'Ast styling starting, text ';
		nextPutAll: styledTextDocumentId printString;
		nextPutAll: ' size ';
		print: (styledText ifNotNil: [ :aText | aText size ]);
		nextPutAll: ', ast ';
		nextPutAll: coderAstDocumentId printString;
		space
]
