"
I am a basic value holder, identifying that a value does not exist.
Users can use {{gtMethod:GtCoderUndefinedObject>>#ifDefined:ifNone:}} to distinguish between defined and undefined values.

"
Class {
	#name : #GtCoderUndefinedObject,
	#superclass : #Object,
	#traits : 'TGtCoderObject + TGtUniqueInstance',
	#classTraits : 'TGtCoderObject classTrait + TGtUniqueInstance classTrait',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'GToolkit-Coder-Object Holder'
}

{ #category : #printing }
GtCoderUndefinedObject >> gtDisplayOn: aStream [
	aStream nextPutAll: 'Missing object'
]

{ #category : #'api - accessing' }
GtCoderUndefinedObject >> ifDefined: definedBlock ifNone: noneBlock [
	^ noneBlock value
]

{ #category : #printing }
GtCoderUndefinedObject >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: 'Missing object';
		nextPut: $)
]
