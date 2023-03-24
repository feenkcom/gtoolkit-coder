"
I contain properties for how a coder should send notifications when code changes.

Currently I indicate if code should be changed syncronously or asyncronously.


"
Class {
	#name : #GtCoderUpdateStrategy,
	#superclass : #Object,
	#instVars : [
		'announcementSource',
		'isSynchronous',
		'properties',
		'textEditCommand'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'gt - extensions' }
GtCoderUpdateStrategy >> gtViewPropertiesFor: aView [
	<gtView>
	
	(properties isNil or: [ properties isEmpty ]) ifTrue: [ ^ aView empty ].
	
	^ aView forward
		title: 'Properties';
		priority: 100;
		object: [ properties ];
		view: #gtItemsFor:
]

{ #category : #'accessing - properties' }
GtCoderUpdateStrategy >> hasPropertyNamed: aPropertyName [ 
	^ self properties includesKey: aPropertyName 
]

{ #category : #testing }
GtCoderUpdateStrategy >> hasTextEditCommand [
	^ self textEditCommand notNil
]

{ #category : #accessing }
GtCoderUpdateStrategy >> isSynchronous [
	^ isSynchronous ifNil: [ false ]
]

{ #category : #accessing }
GtCoderUpdateStrategy >> isSynchronous: anObject [
	isSynchronous := anObject
]

{ #category : #accessing }
GtCoderUpdateStrategy >> makeAsynchronous [
	isSynchronous := false
]

{ #category : #accessing }
GtCoderUpdateStrategy >> makeSynchronous [
	isSynchronous := true
]

{ #category : #copying }
GtCoderUpdateStrategy >> postCopy [
	properties := properties copy
]

{ #category : #'accessing - properties' }
GtCoderUpdateStrategy >> properties [ 
	^ properties ifNil: [
	 	properties := OrderedDictionary new]
]

{ #category : #'accessing - properties' }
GtCoderUpdateStrategy >> propertyNamed: aPropertyName [
	^ self properties at: aPropertyName
]

{ #category : #'accessing - properties' }
GtCoderUpdateStrategy >> propertyNamed: aPropertyName ifAbsent: anAbsentBlock [
	^ self properties at: aPropertyName ifAbsent: anAbsentBlock
]

{ #category : #'accessing - properties' }
GtCoderUpdateStrategy >> propertyNamed: aPropertyName put: aValue [
	^ self properties at: aPropertyName put: aValue
]

{ #category : #accessing }
GtCoderUpdateStrategy >> source [
	^ announcementSource
]

{ #category : #accessing }
GtCoderUpdateStrategy >> source: anObject [
	announcementSource := anObject
]

{ #category : #accessing }
GtCoderUpdateStrategy >> textEditCommand [
	^ textEditCommand
]

{ #category : #accessing }
GtCoderUpdateStrategy >> textEditCommand: anObject [
	textEditCommand := anObject
]
