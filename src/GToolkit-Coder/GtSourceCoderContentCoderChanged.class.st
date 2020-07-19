Class {
	#name : #GtSourceCoderContentCoderChanged,
	#superclass : #BrChangeEvent,
	#instVars : [
		'sourceCoder'
	],
	#category : #'GToolkit-Coder-UI - Source Coder'
}

{ #category : #accessing }
GtSourceCoderContentCoderChanged >> sourceCoder [
	^ sourceCoder
]

{ #category : #accessing }
GtSourceCoderContentCoderChanged >> sourceCoder: anObject [
	sourceCoder := anObject
]
