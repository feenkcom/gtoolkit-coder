Class {
	#name : #GtTextualCoderTextAttributes,
	#superclass : #Object,
	#instVars : [
		'markerAttribute',
		'textAttributes'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #'api - attribute' }
GtTextualCoderTextAttributes >> applyOnEditorText: aText [
	aText
		findAttribute: markerAttribute
		indicesDo: [ :aStartPosition :anEndPosition |
			aText attributes: textAttributes from: aStartPosition to: anEndPosition ]
]

{ #category : #accessing }
GtTextualCoderTextAttributes >> markerAttribute [
	^ markerAttribute
]

{ #category : #accessing }
GtTextualCoderTextAttributes >> markerAttribute: anObject [
	markerAttribute := anObject
]

{ #category : #'api - attribute' }
GtTextualCoderTextAttributes >> removeFromEditorText: aText [
	aText removeAttributes: { self markerAttribute }, self textAttributes
]

{ #category : #accessing }
GtTextualCoderTextAttributes >> textAttributes [
	^ textAttributes
]

{ #category : #accessing }
GtTextualCoderTextAttributes >> textAttributes: anObject [
	textAttributes := anObject
]
