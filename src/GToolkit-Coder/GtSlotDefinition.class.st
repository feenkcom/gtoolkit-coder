Class {
	#name : #GtSlotDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'name',
		'type'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtSlotDefinition class >> fromSlot: aSlot [
	^ self new fromSlot: aSlot
]

{ #category : #'instance creation' }
GtSlotDefinition class >> named: aName [
	^ self new fromSlot: (InstanceVariableSlot named: aName asSymbol)
]

{ #category : #initialization }
GtSlotDefinition >> fromSlot: aSlot [
	name := aSlot name.
	type := aSlot class name
]

{ #category : #initialization }
GtSlotDefinition >> initialize [
	super initialize.
	
	
]

{ #category : #accessing }
GtSlotDefinition >> name [
	^ name
]

{ #category : #accessing }
GtSlotDefinition >> name: anObject [
	name := anObject
]

{ #category : #printing }
GtSlotDefinition >> printOn: aStream [
	aStream
		print: self name;
		nextPutAll: ' => ';
		print: self type
]

{ #category : #accessing }
GtSlotDefinition >> type [
	^ type
]

{ #category : #accessing }
GtSlotDefinition >> type: anObject [
	type := anObject
]
