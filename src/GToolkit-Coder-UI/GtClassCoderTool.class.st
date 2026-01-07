Class {
	#name : #GtClassCoderTool,
	#superclass : #GtCoderTool,
	#traits : 'TGtPhlowWithSelfObjectHolder',
	#classTraits : 'TGtPhlowWithSelfObjectHolder classTrait',
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
GtClassCoderTool class >> forClass: aClass selfObjectHolder: aSelfObjectHolder [
	^ self new
		observedClass: aClass;
		selfObjectHolder: aSelfObjectHolder
]

{ #category : #'instance creation' }
GtClassCoderTool class >> observedClass: aClass [ 
	^ self new observedClass: aClass
]

{ #category : #converting }
GtClassCoderTool >> newCoder [
	^ self
		ifSelfObject: [ :aSelfObject | GtCoderElement forObject: aSelfObject ]
		ifNone: [ GtCoderElement forClass: self observedClass instanceSide ]
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

{ #category : #'api - accessing' }
GtClassCoderTool >> title [
	^ observedClass ifNil: [ super name ] ifNotNil: [ :aClass | aClass name ]
]
