Class {
	#name : #GtClassCoderTool,
	#superclass : #GtCoderTool,
	#instVars : [
		'observedClass'
	],
	#category : #'GToolkit-Coder-Adaptors'
}

{ #category : #'instance creation' }
GtClassCoderTool class >> observedClass: aClass [ 
	^ self new observedClass: aClass
]

{ #category : #converting }
GtClassCoderTool >> newCoder [
	^ GtCoder forClass: self observedClass
]

{ #category : #converting }
GtClassCoderTool >> newCoderFor: aClass [
	^ GtCoder forClass: aClass
]

{ #category : #accessing }
GtClassCoderTool >> observedClass [
	^ observedClass
]

{ #category : #accessing }
GtClassCoderTool >> observedClass: anObject [
	observedClass := anObject
]
