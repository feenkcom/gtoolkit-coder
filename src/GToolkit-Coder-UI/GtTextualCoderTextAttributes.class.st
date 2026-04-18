Class {
	#name : #GtTextualCoderTextAttributes,
	#superclass : #Object,
	#instVars : [
		'markerAttribute',
		'textAttributes',
		'textAttributeTags',
		'markerAttributeTag',
		'documentId',
		'startPosition',
		'stopPosition'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model'
}

{ #category : #'api - attribute' }
GtTextualCoderTextAttributes >> applyOnEditorElement: aTextEditorElement receivedText: aText from: aStartPosition to: anEndPosition [
	| attributesRange |
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
	
	attributesRange := BrTextCharacterRange
		start: aStartPosition
		end: anEndPosition
		documentId: documentId.
	
	markerAttributeTag := aTextEditorElement
		addAttribute: markerAttribute
		overRange: attributesRange.
	
	textAttributeTags := textAttributes collect: [ :eachAttribute |
		aTextEditorElement
			addAttribute: eachAttribute
			overRange: attributesRange ]
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

{ #category : #'gt - extensions' }
GtTextualCoderTextAttributes >> gtAttributes [
	textAttributes ifNil: [ ^ #() ].
	^ Array
		new: textAttributes size + 1
		streamContents: [ :aStream | 
			aStream nextPut: markerAttributeTag -> markerAttribute.
			textAttributes
				withIndexDo: [ :anAttribute :anIndex | 
					| aTag |
					aTag := textAttributeTags at: anIndex ifAbsent: [ nil ].
					aStream nextPut: aTag -> anAttribute ] ]
]

{ #category : #'gt - extensions' }
GtTextualCoderTextAttributes >> gtAttributesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Attributes';
		items: [ self gtAttributes ];
		column: 'Tag' text: #key width: 60;
		column: 'Attribute' text: #value;
		send: #value
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

{ #category : #printing }
GtTextualCoderTextAttributes >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		print: documentId;
		nextPut: $)
]

{ #category : #'api - attribute' }
GtTextualCoderTextAttributes >> removeFromEditorElement: aTextEditorElement [
	(aTextEditorElement isKindOf: BrEditorElement)
		ifTrue: [ self removeFromEditorText: aTextEditorElement text.
			^ self ].
			
	"We assume it is a GtTextEditorElement element."
	self flag: #TODO.
	
	textAttributeTags do: [ :eachTagToRemove |
		aTextEditorElement removeAttributeTagged: eachTagToRemove overMarker: markerAttribute ].
	
	aTextEditorElement removeAttributeTagged: markerAttributeTag
]

{ #category : #'api - attribute' }
GtTextualCoderTextAttributes >> removeFromEditorText: aText [
	"Can be used only on the BrEditorElement kind of editors. Not on GtTextEditorElement."

	aText removeAttributes: { self markerAttribute }, self textAttributes
]

{ #category : #accessing }
GtTextualCoderTextAttributes >> startPosition [
	^ startPosition
]

{ #category : #accessing }
GtTextualCoderTextAttributes >> startPosition: anObject [
	startPosition := anObject
]

{ #category : #accessing }
GtTextualCoderTextAttributes >> stopPosition [
	^ stopPosition
]

{ #category : #accessing }
GtTextualCoderTextAttributes >> stopPosition: anObject [
	stopPosition := anObject
]

{ #category : #accessing }
GtTextualCoderTextAttributes >> textAttributes [
	^ textAttributes
]

{ #category : #accessing }
GtTextualCoderTextAttributes >> textAttributes: anObject [
	textAttributes := anObject
]
