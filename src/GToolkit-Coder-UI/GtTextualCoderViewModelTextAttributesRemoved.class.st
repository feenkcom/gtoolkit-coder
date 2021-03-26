Class {
	#name : #GtTextualCoderViewModelTextAttributesRemoved,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'coderTextAttributes'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesRemoved >> coderTextAttributes [
	^ coderTextAttributes
]

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesRemoved >> coderTextAttributes: anObject [
	coderTextAttributes := anObject
]
