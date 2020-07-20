Class {
	#name : #GtFixItAction,
	#superclass : #Object,
	#instVars : [
		'node',
		'sourceCoder'
	],
	#category : #'GToolkit-Coder-FixIt'
}

{ #category : #'instance creation' }
GtFixItAction class >> forCoder: aSourceCoder node: aRBProgramNode [
	^ self new
		sourceCoder: aSourceCoder;
		node: aRBProgramNode;
		yourself
]

{ #category : #accessing }
GtFixItAction >> description [
	self subclassResponsibility
]

{ #category : #executing }
GtFixItAction >> execute [
	self subclassResponsibility
]

{ #category : #accessing }
GtFixItAction >> menuAction [
	^ GtCoderContextMenuAction new
		action: [ :anEditorElement | 
			self execute ];
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
