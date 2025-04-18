Class {
	#name : #GtClassCoderTool,
	#superclass : #GtCoderTool,
	#instVars : [
		'observedClass'
	],
	#category : #'GToolkit-Coder-UI-Tools'
}

{ #category : #'instance creation' }
GtClassCoderTool class >> forClass: aClass [ 
	^ self new observedClass: aClass
]

{ #category : #'instance creation' }
GtClassCoderTool class >> observedClass: aClass [ 
	^ self new observedClass: aClass
]

{ #category : #'as yet unclassified' }
GtClassCoderTool >> name [
	^ observedClass 
		ifNil: [super name] 
		ifNotNil: [ :aClass | aClass name ]
]

{ #category : #converting }
GtClassCoderTool >> newCoder [
	^ GtCoderElement forClass: self observedClass instanceSide
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
