Class {
	#name : #GtCoderAction,
	#superclass : #Object,
	#instVars : [
		'title',
		'icon',
		'action',
		'id'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #accessing }
GtCoderAction >> action [
	^ action
]

{ #category : #accessing }
GtCoderAction >> action: anObject [
	action := anObject
]

{ #category : #evaluating }
GtCoderAction >> glamourValueWithArgs: aSequenceOfArguments [
	^ self action glamourValueWithArgs: aSequenceOfArguments
]

{ #category : #accessing }
GtCoderAction >> hoverAction [
	^ nil
]

{ #category : #accessing }
GtCoderAction >> icon [
	^ icon
]

{ #category : #accessing }
GtCoderAction >> icon: anObject [
	icon := anObject
]

{ #category : #accessing }
GtCoderAction >> id [
	<return: #Object>
	
	^ id
]

{ #category : #accessing }
GtCoderAction >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtCoderAction >> leaveAction [
	^ nil
]

{ #category : #accessing }
GtCoderAction >> name [
	^ id
]

{ #category : #accessing }
GtCoderAction >> name: anObject [
	id := anObject
]

{ #category : #printing }
GtCoderAction >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (self title ifNil: ['']);
		nextPut: $)
]

{ #category : #accessing }
GtCoderAction >> title [
	^ title
]

{ #category : #accessing }
GtCoderAction >> title: anObject [
	title := anObject
]

{ #category : #evaluating }
GtCoderAction >> valueWithArguments: aSequenceOfArguments [
	^ self action valueWithArguments: aSequenceOfArguments
]
