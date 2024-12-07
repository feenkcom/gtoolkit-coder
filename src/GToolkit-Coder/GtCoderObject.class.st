"
I am a basic value holder, identifying an existing value.
Users can use {{gtMethod:GtCoderObject>>#ifDefined:ifNone:}} to distinguish between defined and undefined values.

"
Class {
	#name : #GtCoderObject,
	#superclass : #Object,
	#traits : 'TGtCoderObject',
	#classTraits : 'TGtCoderObject classTrait',
	#instVars : [
		'value'
	],
	#category : #'GToolkit-Coder-Object Holder'
}

{ #category : #'instance creation' }
GtCoderObject class >> forValue: anObject [
	^ self new value: anObject
]

{ #category : #comparing }
GtCoderObject >> = anObject [
	self == anObject ifTrue: [ ^ true ].

	^ self class = anObject class and: [ self value = anObject value ]
]

{ #category : #printing }
GtCoderObject >> gtDisplayOn: aStream [
	self value gtDisplayOn: aStream
]

{ #category : #comparing }
GtCoderObject >> hash [
	^ self value hash
]

{ #category : #'api - accessing' }
GtCoderObject >> ifDefined: definedBlock ifNone: noneBlock [
	^ definedBlock cull: value
]

{ #category : #printing }
GtCoderObject >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		print: value;
		nextPut: $)
]

{ #category : #accessing }
GtCoderObject >> value [
	^ value
]

{ #category : #accessing }
GtCoderObject >> value: anObject [
	value := anObject
]
