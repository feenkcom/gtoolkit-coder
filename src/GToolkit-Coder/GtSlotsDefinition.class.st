"
I represent local slots of a behavior (class or trait)
"
Class {
	#name : #GtSlotsDefinition,
	#superclass : #GtCompositeDefinition,
	#category : #'GToolkit-Coder-Behavior - Definitions'
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
	| aSlotName aNewSlot |
	
	aSlotName := aSymbol asSymbol.
	
	(self hasDefinitionNamed: aSlotName)
		ifTrue: [ self errorSlotAlreadyExists: aSlotName ].

	aNewSlot := GtSlotDefinition named: aSlotName.
	definitions := definitions copyWith: aNewSlot.

	self notifySlotAdded: aNewSlot
]

{ #category : #converting }
GtSlotsDefinition >> asDefinitionString [
	^ String streamContents: [ :str | 
		| isSpecial |
		str nextPutAll: '{ '.
	
		definitions do: [ :eachSlot |
				str nextPutAll: eachSlot asDefinitionString.
				isSpecial := eachSlot isSpecial ]
			separatedBy: [ 
				str nextPutAll: '. '.  
				isSpecial ifTrue: [ str cr;tab;tab;tab;tab ] ].
			
		definitions ifNotEmpty: [ str nextPutAll: '.'  ].

		str nextPutAll: ' }'. ]
]

{ #category : #'api - accepting' }
GtSlotsDefinition >> differenceWith: aGtSlotsDefinition [
	| theDifference |

	theDifference := GtSlotsDefinitionDifference new.

	GtCodeDefinitionDifference
		difference: self all
		with: aGtSlotsDefinition all
		addedDo: [ :eachSlot | theDifference add: (GtSlotAddedDifference new slotName: eachSlot name) ]
		renamedDo: [ :eachSlot | theDifference add: (GtSlotRenamedDifference new
			slotName: eachSlot originalName;
			oldName: eachSlot originalName;
			newName: eachSlot name) ]
		removedDo: [ :eachSlot | theDifference add: (GtSlotRemovedDifference new slotName: eachSlot name) ].
		
	^ theDifference
]

{ #category : #'gt - editors' }
GtSlotsDefinition >> editors [
	^ { self slotsEditor }
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
	definitions := aClass localSlots collect: [ :eachSlot | (GtSlotDefinition fromSlot: eachSlot) parent: self ]
]

{ #category : #initialization }
GtSlotsDefinition >> fromTrait: aTrait [
	definitions := aTrait localSlots collect: [ :eachSlot | (GtSlotDefinition fromSlot: eachSlot) parent: self ]
]

{ #category : #'gt-extension' }
GtSlotsDefinition >> gtSlotsFor: aView [
	<gtView>
	
	self isEmpty
		ifTrue: [ ^ aView empty ].

	^ aView columnedList
		title: 'Slots';
		priority: 1;
		items: [ definitions ];
		column: 'Name' item: [ :eachSlot | eachSlot name ];
		column: 'Type' item: [ :eachSlot | eachSlot type ]
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

{ #category : #'api - slots' }
GtSlotsDefinition >> removeSlotNamed: aSymbol [
	| aRemovedSlot |
	
	(self hasDefinitionNamed: aSymbol)
		ifFalse: [ self errorSlotNotFound: aSymbol ].
	
	aRemovedSlot := self slotNamed: aSymbol.
	definitions := definitions copyWithout: aRemovedSlot.
	self notifySlotRemoved: aRemovedSlot
]

{ #category : #'api - slots' }
GtSlotsDefinition >> renameSlotNamed: aCurrentName to: aNewName [
	| aRenamedSlot |
	
	(self hasDefinitionNamed: aCurrentName)
		ifFalse: [ self errorSlotNotFound: aCurrentName ].
		
	(self hasDefinitionNamed: aNewName)
		ifTrue: [ self errorSlotAlreadyExists: aCurrentName ].

	aRenamedSlot := self slotNamed: aCurrentName.
	aRenamedSlot name: aNewName.
	
	self
		notifySlotRenamed: aRenamedSlot
		from: aCurrentName
		to: aNewName
]

{ #category : #'api - slots' }
GtSlotsDefinition >> slotNamed: aSymbol [
	<return: #GtSlotDefinition>
	
	^ self
		definitionNamed: aSymbol 
		ifNone: [ self errorSlotNotFound: aSymbol ]
]

{ #category : #'gt - editors' }
GtSlotsDefinition >> slotsEditor [
	<return: #GtCodeDefinitionViewer>
	
	^ GtCodeDefinitionPluralEditor new
		title: self title;
		definition: self;
		addSelector: #addSlotNamed:;
		removeSelector: #removeSlotNamed:;
		renameSelector: #renameSlotNamed:to:;
		getSelector: #names;
		modelSelector: #slotNamed:;
		addEvent: GtBehaviorSlotAdded;
		removeEvent: GtBehaviorSlotRemoved;
		renameEvent: GtBehaviorSlotRenamed;
		whenKey: BlKeyCombination primaryG
			do: [ :anEvent :aDefinition | aDefinition inspectFrom: anEvent ];
		whenKey: BlKeyCombination primaryB
			do: [ :anEvent :aDefinition | aDefinition browseFrom: anEvent ];
		whenKey: BlKeyCombination primaryN
			do: [ :anEvent :aDefinition | aDefinition browseReferencesFrom: anEvent ];
		whenKey: BlKeyCombination primaryC do: [ :anEvent :aDefinition  |
			Clipboard clipboardText: aDefinition name asString ];
		whenPrimaryClickDo: [ :anEvent :aDefinition | aDefinition browseFrom: anEvent ]
]

{ #category : #'gt - editors' }
GtSlotsDefinition >> title [
	^ 'Slots'
]
