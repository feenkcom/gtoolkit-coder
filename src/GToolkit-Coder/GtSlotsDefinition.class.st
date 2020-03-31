"
I represent local slots of a behavior (class or trait)
"
Class {
	#name : #GtSlotsDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'slots'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #'instance creation' }
GtSlotsDefinition class >> fromClass: aClass [
	^ self new fromClass: aClass
]

{ #category : #'instance creation' }
GtSlotsDefinition class >> fromTrait: aTrait [
	^ self new fromTrait: aTrait
]

{ #category : #'api - slots' }
GtSlotsDefinition >> addSlotNamed: aSymbol [
	| aNewSlot |
	
	(self hasSlotNamed: aSymbol)
		ifTrue: [ self errorSlotAlreadyExists: aSymbol ].

	aNewSlot := GtSlotDefinition named: aSymbol.
	slots := slots copyWith: aNewSlot.

	self notifySlotAdded: aNewSlot
]

{ #category : #accessing }
GtSlotsDefinition >> at: anIndex [
	<return: #GtSlotDefinition>

	^ slots at: anIndex
]

{ #category : #'private - errors' }
GtSlotsDefinition >> errorSlotAlreadyExists: aSymbol [ 
	"Create an error notification that there is already a slot with a given name"

	GtBehaviorCoderHeaderSlotAlreadyExistsError signalFor: aSymbol
]

{ #category : #'private - errors' }
GtSlotsDefinition >> errorSlotNotFound: aSymbol [ 
	"Create an error notification that there is no slot with a given name"

	GtBehaviorCoderHeaderSlotNotFoundError signalFor: aSymbol
]

{ #category : #initialization }
GtSlotsDefinition >> fromClass: aClass [
	slots := aClass localSlots collect: [ :eachSlot | (GtSlotDefinition fromSlot: eachSlot) parent: self ]
]

{ #category : #initialization }
GtSlotsDefinition >> fromTrait: aTrait [
	slots := aTrait localSlots collect: [ :eachSlot | (GtSlotDefinition fromSlot: eachSlot) parent: self ]
]

{ #category : #'gt-extension' }
GtSlotsDefinition >> gtSlotsFor: aView [
	<gtView>
	
	slots
		ifEmpty: [ ^ aView empty ].

	^ aView columnedList
		title: 'Slots';
		priority: 1;
		items: [ slots ];
		column: 'Name' item: [ :eachSlot | eachSlot name ];
		column: 'Type' item: [ :eachSlot | eachSlot type ]
]

{ #category : #'api - slots' }
GtSlotsDefinition >> hasSlotNamed: aSymbol [
	<return: #Boolean>

	^ slots
		detect: [ :eachSlotDefinition | eachSlotDefinition name = aSymbol ]
		ifFound: [ true ]
		ifNone: [ false ]
]

{ #category : #accessing }
GtSlotsDefinition >> names [
	<return: #Collection of: #Symbol>
	
	^ slots collect: [ :eachSlot | eachSlot name ]
]

{ #category : #'private - notifying' }
GtSlotsDefinition >> notifySlotAdded: aGtSlotDefinition [
	self dispatchEvent: (GtBehaviorSlotAdded new
		slot: aGtSlotDefinition;
		owner: self parent)
]

{ #category : #'private - notifying' }
GtSlotsDefinition >> notifySlotRemoved: aGtSlotDefinition [
	self dispatchEvent: (GtBehaviorSlotRemoved new
		slot: aGtSlotDefinition;
		owner: self parent)
]

{ #category : #'private - notifying' }
GtSlotsDefinition >> notifySlotRenamed: aGtSlotDefinition from: anOldName to: aNewName [
	self dispatchEvent: (GtBehaviorSlotRenamed new
		slot: aGtSlotDefinition;
		owner: self parent;
		oldName: anOldName;
		newName: aNewName)
]

{ #category : #accessing }
GtSlotsDefinition >> parent: aParent [
	super parent: aParent.
	
	slots do: [ :eachSlot | eachSlot parent: aParent ]
]

{ #category : #'api - slots' }
GtSlotsDefinition >> removeSlotNamed: aSymbol [
	| aRemovedSlot |
	
	(self hasSlotNamed: aSymbol)
		ifFalse: [ self errorSlotNotFound: aSymbol ].
	
	aRemovedSlot := self slotNamed: aSymbol.
	slots := slots copyWithout: aRemovedSlot.
	self notifySlotRemoved: aRemovedSlot
]

{ #category : #'api - slots' }
GtSlotsDefinition >> renameSlotNamed: aCurrentName to: aNewName [
	| aRenamedSlot |
	
	(self hasSlotNamed: aCurrentName)
		ifFalse: [ self errorSlotNotFound: aCurrentName ].

	aRenamedSlot := self slotNamed: aCurrentName.
	aRenamedSlot name: aNewName.
	
	self
		notifySlotRenamed: aRenamedSlot
		from: aCurrentName
		to: aNewName
]

{ #category : #accessing }
GtSlotsDefinition >> size [
	<return: #Number>
	
	^ slots size
]

{ #category : #'api - slots' }
GtSlotsDefinition >> slotNamed: aSymbol [
	<return: #GtSlotDefinition>
	
	^ slots
		detect: [ :eachSlotDefinition | eachSlotDefinition name = aSymbol ]
		ifNone: [ self errorSlotNotFound: aSymbol ]
]
