Class {
	#name : #GtClassCoderTool,
	#superclass : #GtCoderTool,
	#instVars : [
		'observedClass'
	],
	#category : #'GToolkit-Coder-Adaptors'
}

{ #category : #'instance creation' }
GtClassCoderTool class >> forClass: aClass [ 
	^ self new observedClass: aClass
]

{ #category : #'instance creation' }
GtClassCoderTool class >> observedClass: aClass [ 
	^ self new observedClass: aClass
]

{ #category : #converting }
GtClassCoderTool >> newCoder [
	^ GtCoder forClass: self observedClass
]

{ #category : #accessing }
GtClassCoderTool >> object [
	"compatibility method for ${GLMBlocObjectToSelect}$"
	^ self observedClass
]

{ #category : #accessing }
GtClassCoderTool >> observedClass [
	^ observedClass
]

{ #category : #accessing }
GtClassCoderTool >> observedClass: anObject [
	observedClass := anObject
]
