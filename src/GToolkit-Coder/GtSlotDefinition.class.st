Class {
	#name : #GtSlotDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'originalName',
		'name',
		'type'
	],
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtSlotDefinition class >> fromSlot: aSlot [
	^ self new fromSlot: aSlot
]

{ #category : #'instance creation' }
GtSlotDefinition class >> named: aName [
	^ self new named: aName
]

{ #category : #converting }
GtSlotDefinition >> asDefinitionString [
	^ String streamContents: [ :aStream |
		aStream
			print: self name.
		self isSpecial
			ifTrue: [
				aStream
					nextPutAll: ' => ';
					print: self type ] ]
]

{ #category : #'api - slot' }
GtSlotDefinition >> browseFrom: anEvent [
	anEvent currentTarget phlow spawnObject: self
]

{ #category : #'api - slot' }
GtSlotDefinition >> browseReferencesFrom: anEvent [
	parent classOrMetaClass
		ifNotNil: [ :class | 
			anEvent currentTarget phlow
				spawnObject:
					(GtSearchInstanceVariableReferenceFilter
						forClassAndSubclasses: class
						andVariable: self name) ]
]

{ #category : #initialization }
GtSlotDefinition >> defaultSlotType [
	^ InstanceVariableSlot name
]

{ #category : #initialization }
GtSlotDefinition >> fromSlot: aSlot [

	self
		assert: [ aSlot owningClass isNotNil ]
		description: [ 'Slot must belong to a class' ].

	name := aSlot name.
	originalName := name.
	type := (aSlot printString copyAfter: $>) trimBoth asSymbol
]

{ #category : #initialization }
GtSlotDefinition >> initialize [
	super initialize.
	
	
]

{ #category : #testing }
GtSlotDefinition >> isSpecial [
	^ self type ~= self defaultSlotType
]

{ #category : #testing }
GtSlotDefinition >> isValidName [
	^ RBScanner isVariable: self name
]

{ #category : #accessing }
GtSlotDefinition >> name [
	^ name
]

{ #category : #accessing }
GtSlotDefinition >> name: anObject [
	name := anObject asSymbol
]

{ #category : #initialization }
GtSlotDefinition >> named: aName [
	name := aName.
	originalName := aName.
	type := self defaultSlotType
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
