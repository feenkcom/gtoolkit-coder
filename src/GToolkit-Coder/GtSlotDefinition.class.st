Class {
	#name : #GtSlotDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'originalName',
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
	^ self new
		name: aName;
		type: InstanceVariableSlot name;
		yourself
]

{ #category : #initialization }
GtSlotDefinition >> fromSlot: aSlot [

	self
		assert: [ aSlot owningClass isNotNil ]
		description: [ 'Slot must belong to a class' ].

	name := aSlot name.
	originalName := name.
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
	name := anObject asSymbol
]

{ #category : #accessing }
GtSlotDefinition >> originalName [
	^ originalName
]

{ #category : #accessing }
GtSlotDefinition >> originalName: anObject [
	originalName := anObject
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
