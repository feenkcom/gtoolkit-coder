Class {
	#name : #GtFixItAction,
	#superclass : #Object,
	#instVars : [
		'methodCoder',
		'node'
	],
	#category : #'GToolkit-Coder-FixIt'
}

{ #category : #'instance creation' }
GtFixItAction class >> forCoder: aMethodCoder node: aRBProgramNode [
	^ self new
		methodCoder: aMethodCoder;
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
		action: [ self execute ];
		title: self description
]

{ #category : #initialization }
GtFixItAction >> methodCoder: aCoder [
	methodCoder := aCoder
]

{ #category : #initialization }
GtFixItAction >> node: aRBProgramNode [
	node := aRBProgramNode
]
