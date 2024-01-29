Class {
	#name : #GtSourceCoderRequester,
	#superclass : #Object,
	#traits : 'TGtCoderRequesterObject',
	#classTraits : 'TGtCoderRequesterObject classTrait',
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Coders - Evaluation'
}

{ #category : #accessing }
GtSourceCoderRequester >> coder [
	^ coder
]

{ #category : #accessing }
GtSourceCoderRequester >> coder: anObject [
	coder := anObject
]
