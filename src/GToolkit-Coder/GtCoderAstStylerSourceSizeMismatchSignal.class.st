Class {
	#name : #GtCoderAstStylerSourceSizeMismatchSignal,
	#superclass : #GtCoderAstStylerSignal,
	#instVars : [
		'coderAst',
		'coderAstDocumentId'
	],
	#category : #'GToolkit-Coder-Signals'
}

{ #category : #accessing }
GtCoderAstStylerSourceSizeMismatchSignal >> coderAst [
	^ coderAst
]

{ #category : #accessing }
GtCoderAstStylerSourceSizeMismatchSignal >> coderAst: anObject [
	coderAst := anObject
]

{ #category : #accessing }
GtCoderAstStylerSourceSizeMismatchSignal >> coderAstDocumentId [
	^ coderAstDocumentId
]

{ #category : #accessing }
GtCoderAstStylerSourceSizeMismatchSignal >> coderAstDocumentId: anObject [
	coderAstDocumentId := anObject
]

{ #category : #printing }
GtCoderAstStylerSourceSizeMismatchSignal >> printOneLineContentsOn: aStream [
	| anAstSourceSize aStyledTextSize |
	anAstSourceSize := [ coderAst
			ifNotNil: [ :theCoderAst | theCoderAst ast ifNotNil: [ :theAst | theAst source size ] ] ]
			on: Error
			do: [ :anError | nil ].
	aStyledTextSize := [ styledText ifNotNil: [ :aText | aText characters size ] ]
			on: Error
			do: [ :anError | nil ].

	aStream
		nextPutAll: 'Ast styling skipped, text ';
		nextPutAll: styledTextDocumentId printString;
		nextPutAll: ' size ';
		print: aStyledTextSize;
		nextPutAll: ', ast ';
		nextPutAll: coderAstDocumentId printString;
		nextPutAll: ' source size ';
		print: anAstSourceSize;
		space
]
