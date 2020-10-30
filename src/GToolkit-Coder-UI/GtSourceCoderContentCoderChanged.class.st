Class {
	#name : #GtSourceCoderContentCoderChanged,
	#superclass : #BrChangeEvent,
	#instVars : [
		'sourceCoder'
	],
	#category : #'GToolkit-Coder-UI-Coder - Source Events'
}

{ #category : #accessing }
GtSourceCoderContentCoderChanged >> sourceCoder [
	^ sourceCoder
]

{ #category : #accessing }
GtSourceCoderContentCoderChanged >> sourceCoder: anObject [
	sourceCoder := anObject
]
