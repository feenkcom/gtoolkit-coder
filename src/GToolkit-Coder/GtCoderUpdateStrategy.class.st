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
		'properties'
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
