Class {
	#name : #GtTextualCoderViewModelTextEditCommandRequestAnnouncement,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'textEditCommand'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelTextEditCommandRequestAnnouncement >> textEditCommand [
	^ textEditCommand
]

{ #category : #accessing }
GtTextualCoderViewModelTextEditCommandRequestAnnouncement >> textEditCommand: anObject [
	textEditCommand := anObject
]
