Class {
	#name : #GtClassCoder,
	#superclass : #Announcer,
	#instVars : [
		'navigationModel',
		'class',
		'object'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtClassCoder class >> forClass: aBehavior [
	^ self new
		forClass: aBehavior;
		yourself
]

{ #category : #'instance creation' }
GtClassCoder class >> forObject: anObject [
	^ self new
		forObject: anObject;
		yourself
]

{ #category : #'api - refactoring' }
GtClassCoder >> addSlotNamed: aSymbol ifFailed: anErrorBlock [
	<return: #Boolean>
	| isSuccess |
	
	isSuccess := false.
	
	[ (RBAddInstanceVariableRefactoring
			variable: aSymbol
			class: self theClass) execute.
		isSuccess := true ]
		on: Error
		do: anErrorBlock.

	^ isSuccess
]

{ #category : #elements }
GtClassCoder >> asCardElement [
	| coderElement |
	coderElement := GtClassCardElement new coder: self.
	^ coderElement
]

{ #category : #elements }
GtClassCoder >> asElement [
	| coderElement |
	coderElement := GtBehaviorCoderElement new classCoder: self.
	^ coderElement
]

{ #category : #updating }
GtClassCoder >> forClass: aClass [
	class := aClass.
	self announce: (GtCoderClassUpdatedAnnouncement forClass: class)
]

{ #category : #initialize }
GtClassCoder >> forObject: anObject [
	object := anObject.
	self forClass: anObject class
]

{ #category : #ui }
GtClassCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Class';
		priority: 1;
		stencil: [ self ];
		actionButtonIcon: BrGlamorousVectorIcons browse
			action: [ :aButton | self theClass browse ];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			action: [ :aButton | 
				aButton phlow spawnObject: self theClass ]
		
]

{ #category : #'system annoucements' }
GtClassCoder >> handleClassDefinitionModified: anAnnouncement [

	self theClass
		ifNil: [ ^ self ].

	(anAnnouncement affectsClass: self theClass)
		ifFalse: [ ^ self ].

	self
		notifySlotChangesBetween: anAnnouncement oldClassDefinition
		and: anAnnouncement newClassDefinition
]

{ #category : #'system annoucements' }
GtClassCoder >> handleClassModified: anAnnouncement [
	"anAnnouncement class traceCr"
]

{ #category : #accessing }
GtClassCoder >> icon [
	^ BrGlamorousIcons classicon asElement
]

{ #category : #initialize }
GtClassCoder >> initialize [
	super initialize.

	navigationModel := GtClassCoderPackagesAndHierarchyNavigation new
		classCoder: self;
		yourself.
		
	self subscribeToSystem
]

{ #category : #accessing }
GtClassCoder >> name [
	^ self theClass name
]

{ #category : #accessing }
GtClassCoder >> navigationModel [
	^ navigationModel
]

{ #category : #accessing }
GtClassCoder >> navigationModel: aNavigationModel [
	navigationModel := aNavigationModel.
	navigationModel classCoder: self.
	self announce: GtCoderNavigationModelChangedAnnouncement
]

{ #category : #'private - changes' }
GtClassCoder >> notifySlotChangesBetween: anOldClassDefinition and: aNewClassDefinition [
	| theOldSlots theNewSlots theAddedSlots theRemovedSlots theUpdatedSlots theOldSlotsMap theNewSlotsMap |
	
	theOldSlots := anOldClassDefinition slots.
	theNewSlots := aNewClassDefinition slots.
		
	theOldSlotsMap := (theOldSlots collect: [ :eachSlot | eachSlot name -> eachSlot ]) asOrderedDictionary.
	theNewSlotsMap := (theNewSlots collect: [ :eachSlot | eachSlot name -> eachSlot ]) asOrderedDictionary.

	theRemovedSlots := OrderedCollection new.
	theOldSlotsMap do: [ :eachSlot |
		theNewSlotsMap
			at: eachSlot name
			ifAbsent: [ theRemovedSlots add: eachSlot ] ].
	
	theAddedSlots := OrderedCollection new.
	theNewSlotsMap do: [ :eachSlot |
		theOldSlotsMap
			at: eachSlot name
			ifAbsent: [ theAddedSlots add: eachSlot ] ].
		
	theUpdatedSlots := OrderedCollection new.
	theOldSlotsMap do: [ :eachOldSlot |
		theNewSlotsMap
			at: eachOldSlot name
			ifPresent: [ :eachNewSlot |
				eachNewSlot = eachOldSlot
					ifFalse: [ theUpdatedSlots add: (eachOldSlot -> eachNewSlot) ] ] ].
	
	theRemovedSlots
		ifNotEmpty: [ self announce: (GtClassCoderSlotsRemoved new slots: theRemovedSlots) ].
		
	theAddedSlots
		ifNotEmpty: [ self announce: (GtClassCoderSlotsAdded new slots: theAddedSlots) ].
		
	theUpdatedSlots
		ifNotEmpty: [ theUpdatedSlots do: [ :eachChange |
				self announce: (GtClassCoderSlotChanged new oldSlot: eachChange key; newSlot: eachChange value) ] ].

	self announce: (GtClassCoderSlotsChanged new
		oldSlots: theOldSlots;
		newSlots: theNewSlots)
]

{ #category : #accessing }
GtClassCoder >> object [
	^ object
]

{ #category : #opening }
GtClassCoder >> openInInspector [
	| anInspector aSpace |
	anInspector := GtInspector new.
	anInspector
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	anInspector addPageWithContent: self asElement for: self.
	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: 'Class Coder'.
	aSpace extent: 1200 @ 600.
	aSpace addChild: anInspector.
	aSpace show
]

{ #category : #accessing }
GtClassCoder >> packageTreeCoders [
	^ #()
]

{ #category : #subscriptions }
GtClassCoder >> subscribeToSystem [
	SystemAnnouncer uniqueInstance weak
		when: ClassAnnouncement
		send: #handleClassModified:
		to: self.
		
	SystemAnnouncer uniqueInstance weak
		when: ClassModifiedClassDefinition
		send: #handleClassDefinitionModified:
		to: self.
]

{ #category : #accessing }
GtClassCoder >> theClass [
	^ class
]

{ #category : #updating }
GtClassCoder >> updateForPackage: aPackage [
	class := nil.
	self announce: (GtCoderPackageUpdatedAnnouncement new package: aPackage)
]

{ #category : #scripting }
GtClassCoder >> withClass: aClass [
	self forClass: aClass
]

{ #category : #scripting }
GtClassCoder >> withSelectedMethod: aMethod [
	self withClass: aMethod methodClass.
	self
		announce: (GtClassCoderNavigationAnnouncement new method: aMethod)
]
