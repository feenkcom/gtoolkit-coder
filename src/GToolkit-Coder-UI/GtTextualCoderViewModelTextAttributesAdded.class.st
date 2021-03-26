Class {
	#name : #GtTextualCoderViewModelTextAttributesAdded,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'coderTextAttributes'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesAdded >> coderTextAttributes [
	^ coderTextAttributes
]

{ #category : #accessing }
GtTextualCoderViewModelTextAttributesAdded >> coderTextAttributes: anObject [
	coderTextAttributes := anObject
]
