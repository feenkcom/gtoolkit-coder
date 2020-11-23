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

{ #category : #accessing }
GtFixItAction >> attributePosition [
	^ node stop
]

{ #category : #private }
GtFixItAction >> clearFixItAttributeInEditor: aBrTextEditor [
	| position |
	position := self attributePosition.
	(aBrTextEditor text from: position to: position)
		clearAttributes: [ :each | each isKindOf: GtFixItAttribute ]
]

{ #category : #accessing }
GtFixItAction >> description [
	self subclassResponsibility
]

{ #category : #executing }
GtFixItAction >> executeOn: anEditorElement [
	self subclassResponsibility
]

{ #category : #accessing }
GtFixItAction >> menuAction [
	^ GtCoderContextMenuAction new
		action: [ :anEditorElement | self executeOn: anEditorElement ];
		title: self description
]

{ #category : #initialization }
GtFixItAction >> node: aRBProgramNode [
	node := aRBProgramNode
]

{ #category : #initialization }
GtFixItAction >> sourceCoder: aCoder [
	sourceCoder := aCoder
]
