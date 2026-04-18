Class {
	#name : #GtTextualCoderEditorElementUpdateTextRequestedSignal,
	#superclass : #GtTextualCoderEditorElementSignal,
	#instVars : [
		'text'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual'
}

{ #category : #printing }
GtTextualCoderEditorElementUpdateTextRequestedSignal >> printOneLineContentsOn: aStream [

 text gtDisplayOn: aStream.
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElementUpdateTextRequestedSignal >> text [
	^ text
]

{ #category : #'private - event handling' }
GtTextualCoderEditorElementUpdateTextRequestedSignal >> text: aBlText [
	text := aBlText
]
