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
GtTextualCoderTextAttributes >> applyOnEditorElement: aTextEditorElement receivedText: aText from: aStartPosition to: anEndPosition [
	(aTextEditorElement isKindOf: BrEditorElement)
		ifTrue: [ aText characters = aTextEditorElement text characters
				ifTrue: [ self
						applyOnEditorText: aTextEditorElement text
						from: aStartPosition
						to: anEndPosition ].
			^ self ].
			
	"We assume it is a GtTextEditorElement element.
	I think the markerAttribute is simply ignored."
	
	self flag: #TODO.
	aTextEditorElement addAttribute: markerAttribute from: aStartPosition to: anEndPosition.
	textAttributes do: [ :eachAttribute |
		aTextEditorElement addAttribute: eachAttribute from: aStartPosition to: anEndPosition ]
]

{ #category : #'api - attribute' }
GtTextualCoderTextAttributes >> applyOnEditorText: aText [
	"It is called from `GtTextualCoderViewModel>>#asEditorState`
	and seems to be ok."

	aText
		findAttribute: markerAttribute
		indicesDo: [ :aStartPosition :anEndPosition |
			aText attributes: textAttributes from: aStartPosition to: anEndPosition ]
]

{ #category : #'api - attribute' }
GtTextualCoderTextAttributes >> applyOnEditorText: aText from: aStartPosition to: anEndPosition [
	"Can be used only on the BrEditorElement kind of editors. Not on GtTextEditorElement."

	aText
		findAttribute: markerAttribute
		indicesDo: [ :aMarkerStartPosition :aMarkerEndPosition |
			^ aText attributes: textAttributes from: aMarkerStartPosition to: aMarkerEndPosition ].
		
	aText attributes: { markerAttribute }, textAttributes from: aStartPosition to: anEndPosition
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
GtTextualCoderTextAttributes >> removeFromEditorElement: aTextEditorElement [
	(aTextEditorElement isKindOf: BrEditorElement)
		ifTrue: [ self removeFromEditorText: aTextEditorElement text.
			^ self ].
			
	"We assume it is a GtTextEditorElement element."
	self flag: #TODO.
	
	aTextEditorElement removeTextAttribute: markerAttribute.
	textAttributes do: [ :eachAttribute |
		aTextEditorElement removeTextAttribute: eachAttribute ]
]

{ #category : #'api - attribute' }
GtTextualCoderTextAttributes >> removeFromEditorText: aText [
	"Can be used only on the BrEditorElement kind of editors. Not on GtTextEditorElement."

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
