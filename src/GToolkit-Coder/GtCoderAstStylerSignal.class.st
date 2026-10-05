Class {
	#name : #GtCoderAstStylerSignal,
	#superclass : #GtCoderSignal,
	#instVars : [
		'styledText',
		'styledTextDocumentId',
		'coderViewModel'
	],
	#category : #'GToolkit-Coder-Signals'
}

{ #category : #accessing }
GtCoderAstStylerSignal >> coderViewModel [
	^ coderViewModel
]

{ #category : #accessing }
GtCoderAstStylerSignal >> coderViewModel: anObject [
	coderViewModel := anObject
]

{ #category : #accessing }
GtCoderAstStylerSignal >> styledText [
	^ styledText
]

{ #category : #accessing }
GtCoderAstStylerSignal >> styledText: anObject [
	styledText := anObject
]

{ #category : #accessing }
GtCoderAstStylerSignal >> styledTextDocumentId [
	^ styledTextDocumentId
]

{ #category : #accessing }
GtCoderAstStylerSignal >> styledTextDocumentId: anObject [
	styledTextDocumentId := anObject
]
