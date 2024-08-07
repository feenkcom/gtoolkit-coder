Class {
	#name : #GtFixItAction,
	#superclass : #Object,
	#instVars : [
		'node',
		'sourceCoder'
	],
	#category : #'GToolkit-Coder-AddOns-FixIt'
}

{ #category : #'instance creation' }
GtFixItAction class >> forCoder: aSourceCoder node: aRBProgramNode [
	^ self new
		sourceCoder: aSourceCoder;
		node: aRBProgramNode;
		yourself
]

{ #category : #'api - node' }
GtFixItAction >> attributePosition [
	^ node name stopPosition
]

{ #category : #private }
GtFixItAction >> clearFixItAttributeInEditor: aBrTextEditor [
	| position |
	position := self attributePosition.
	aBrTextEditor text
		clearAttributes: position
		to: position
		if: [ :each | each isKindOf: GtFixItAttribute ]
]

{ #category : #'api - action' }
GtFixItAction >> description [
	self subclassResponsibility
]

{ #category : #executing }
GtFixItAction >> executeOn: anEditorElement [
	self subclassResponsibility
]

{ #category : #'api - action' }
GtFixItAction >> id [
	<return: #BlElementId>

	^ self subclassResponsibility
]

{ #category : #private }
GtFixItAction >> menuActionWithIndex: anIndex [
	^ GtCoderContextMenuAction new
		action: [ :aCoderViewModel :anEditorElement |
			aCoderViewModel selectNone.
			self executeOn: anEditorElement ];
		title: self description;
		id: (self id indexed: anIndex)
]

{ #category : #initialization }
GtFixItAction >> node: aRBProgramNode [
	node := aRBProgramNode
]

{ #category : #printing }
GtFixItAction >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self description ]
]

{ #category : #initialization }
GtFixItAction >> sourceCoder: aCoder [
	sourceCoder := aCoder
]

{ #category : #'api - node' }
GtFixItAction >> startPosition [
	^ node name startPosition
]

{ #category : #'api - node' }
GtFixItAction >> stopPosition [
	^ node name stopPosition
]
