Class {
	#name : #GtTextualCoderViewModelTextChangedSignal,
	#superclass : #ContextStackSignal,
	#instVars : [
		'text',
		'documentId',
		'textualCoderViewModel'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #accessing }
GtTextualCoderViewModelTextChangedSignal >> documentId [
	^ documentId
]

{ #category : #accessing }
GtTextualCoderViewModelTextChangedSignal >> documentId: anObject [
	documentId := anObject
]

{ #category : #printing }
GtTextualCoderViewModelTextChangedSignal >> printOneLineContentsOn: aStream [

 documentId gtDisplayOn: aStream.
 aStream space.
 text gtDisplayOn: aStream.
]

{ #category : #accessing }
GtTextualCoderViewModelTextChangedSignal >> text [
	^ text
]

{ #category : #accessing }
GtTextualCoderViewModelTextChangedSignal >> text: anObject [
	text := anObject
]

{ #category : #accessing }
GtTextualCoderViewModelTextChangedSignal >> textualCoderViewModel [
	^ textualCoderViewModel
]

{ #category : #accessing }
GtTextualCoderViewModelTextChangedSignal >> textualCoderViewModel: anObject [
	textualCoderViewModel := anObject
]
