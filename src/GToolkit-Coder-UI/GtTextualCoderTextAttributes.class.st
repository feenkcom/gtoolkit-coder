Class {
	#name : #GtTextualCoderTextAttributes,
	#superclass : #Object,
	#instVars : [
		'markerAttribute',
		'textAttributes',
		'textAttributeTags',
		'markerAttributeTag',
		'documentId'
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
	"Investigate what to do when documentId is nil. Can it even be nil here?"
	self assert: [ documentId isNotNil ].
	
	"From where does (aStartPosition to: anEndPosition) come from?"
	self flag: #TODO.
	markerAttributeTag := aTextEditorElement
		addAttribute: markerAttribute
		from: aStartPosition
		to: anEndPosition
		documentId: documentId.
	
	textAttributeTags := textAttributes collect: [ :eachAttribute |
		aTextEditorElement
			addAttribute: eachAttribute
			from: aStartPosition
			to: anEndPosition
			documentId: documentId ]
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
GtTextualCoderTextAttributes >> documentId [
	^ documentId
]

{ #category : #accessing }
GtTextualCoderTextAttributes >> documentId: anObject [
	documentId := anObject
]

{ #category : #'as yet unclassified' }
GtTextualCoderTextAttributes >> initialize [
	super initialize.
	
	markerAttributeTag := 0.
	textAttributeTags := #()
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
	
	textAttributeTags do: [ :eachTagToRemove |
		aTextEditorElement removeAttributeTagged: eachTagToRemove overAdornment: markerAttributeTag ].
	
	aTextEditorElement removeAttributeTagged: markerAttributeTag
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
