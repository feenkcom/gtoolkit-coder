Class {
	#name : #GtPharoBehaviorProtocolCoder,
	#superclass : #GtCoderModel,
	#instVars : [
		'protocolBehavior',
		'protocol',
		'methodCoders'
	],
	#category : #'GToolkit-Coder-Pharo-Coders'
}

{ #category : #'instance creation' }
GtPharoBehaviorProtocolCoder class >> forBehavior: aBehavior protocol: aProtocol [
	^ self new forBehavior: aBehavior protocol: aProtocol
]

{ #category : #'api - converting' }
GtPharoBehaviorProtocolCoder >> asNewCoderModelWithSameSubject [
	"Return new coder model with same subject (e.g., package, class, method)"
	<return: #GtCoderModel>

	^ self shouldNotImplement
]

{ #category : #accessing }
GtPharoBehaviorProtocolCoder >> behavior [
	<return: #Behavior>

	self protocolBehavior realBehaviorDo: [ :aBehavior | ^ aBehavior ].
	^ UndefinedObject
]

{ #category : #initialize }
GtPharoBehaviorProtocolCoder >> forBehavior: aBehavior protocol: aProtocol [
	self
		assert: [ aBehavior notNil ]
		description: [ 'Behavior must not be nil' ].
		
	self
		assert: [ aProtocol notNil ]
		description: [ 'Protocol must not be nil' ].

	protocolBehavior := GtMethodCoderExplicitBehavior new behavior: aBehavior.
	protocol := aProtocol.

	methodCoders removeAll.
	methodCoders addAll: (((aBehavior methods
		select: [ :eachCompiledMethod | eachCompiledMethod protocol = aProtocol ]) sorted: GtMethodsSortFunction new)
			collect: [ :eachCompiledMethod | (GtPharoMethodCoder forMethod: eachCompiledMethod) withoutHeader ])
]

{ #category : #printing }
GtPharoBehaviorProtocolCoder >> gtDisplayOn: aStream [
	super gtDisplayOn: aStream.
	aStream
		space;
		nextPut: $(;
		nextPutAll: self behavior name;
		space;
		nextPut: $|;
		space;
		nextPutAll: self protocol;
		nextPut: $)
]

{ #category : #'gt-extension' }
GtPharoBehaviorProtocolCoder >> gtLiveFor: aView [
	^ aView empty
]

{ #category : #'gt-extension' }
GtPharoBehaviorProtocolCoder >> gtMethodsFor: aView [
	<gtView>
	^ aView list
		title: 'Methods' translated;
		priority: 2;
		items: [ self methodCoders collect: [ :eachMethodCoder | eachMethodCoder asCoderViewModel expanded: false ] ];
		itemType: [ :aTypeFactory :eachViewModel | eachViewModel elementClass ];
		itemStencil: [ :anElementClass | anElementClass new ];
		itemDataBinder: [ :eachCoderElement :eachCoderViewModel | eachCoderElement coderUIModel: eachCoderViewModel ]
]

{ #category : #initialize }
GtPharoBehaviorProtocolCoder >> initialize [
	super initialize.
	
	protocolBehavior := GtMethodCoderUnspecifiedBehavior new.
	methodCoders := OrderedCollection new
]

{ #category : #accessing }
GtPharoBehaviorProtocolCoder >> methodCoders [
	^ methodCoders
]

{ #category : #'private - notifying' }
GtPharoBehaviorProtocolCoder >> notifyClassAdded [
	self announce: (GtCoderClassAdded new coder: self)
]

{ #category : #'private - notifying' }
GtPharoBehaviorProtocolCoder >> notifyClassRemoved [
	self announce: (GtCoderClassRemoved new coder: self)
]

{ #category : #'private - notifying' }
GtPharoBehaviorProtocolCoder >> notifyClassRenamed [
	self announce: (GtCoderClassRenamed new coder: self)
]

{ #category : #'private - event handling' }
GtPharoBehaviorProtocolCoder >> onClassAdded: aClassAddedAnnouncement [
	(self protocolBehavior affectedByClassAdded: aClassAddedAnnouncement)
		ifFalse: [ ^ self ].

	protocolBehavior := self protocolBehavior affectByClassAdded: aClassAddedAnnouncement.
	self notifyClassAdded
]

{ #category : #'private - event handling' }
GtPharoBehaviorProtocolCoder >> onClassRemoved: aClassRemovedAnnouncement [
	(self protocolBehavior affectedByClassRemoved: aClassRemovedAnnouncement)
		ifFalse: [ ^ self ].
		
	protocolBehavior := self protocolBehavior affectByClassRemoved: aClassRemovedAnnouncement.
	self notifyClassRemoved
]

{ #category : #'private - event handling' }
GtPharoBehaviorProtocolCoder >> onClassRenamed: aClassRenamedAnnouncement [
	(self protocolBehavior affectedByClassRenamed: aClassRenamedAnnouncement)
		ifFalse: [ ^ self ].

	protocolBehavior := self protocolBehavior affectByClassRenamed: aClassRenamedAnnouncement.
	self notifyClassRenamed
]

{ #category : #'private - event handling' }
GtPharoBehaviorProtocolCoder >> onMethodAdded: aCompiledMethod [
]

{ #category : #'private - event handling' }
GtPharoBehaviorProtocolCoder >> onMethodRemoved: aCompiledMethod [
]

{ #category : #'private - event handling' }
GtPharoBehaviorProtocolCoder >> onSystemMethodAdded: aMethodAdded [
	aMethodAdded protocol = self protocol
		ifTrue: [ ^ self onMethodAdded: aMethodAdded methodAdded ]
]

{ #category : #'private - event handling' }
GtPharoBehaviorProtocolCoder >> onSystemMethodModified: aMethodModified [
	(aMethodModified oldProtocol = aMethodModified newProtocol
		and: [ aMethodModified oldProtocol = self protocol ])
			ifTrue: [ ^ self ].

	aMethodModified newProtocol = self protocol
		ifTrue: [ ^ self onMethodAdded: aMethodModified newMethod ].

	aMethodModified oldProtocol = self protocol
		ifTrue: [ ^ self onMethodRemoved: aMethodModified oldMethod ].
]

{ #category : #'private - event handling' }
GtPharoBehaviorProtocolCoder >> onSystemMethodRecategorized: aMethodRecategorized [
	aMethodRecategorized newProtocol = self protocol
		ifTrue: [ ^ self onMethodAdded: aMethodRecategorized methodRecategorized ].
		
	aMethodRecategorized oldProtocol = self protocol
		ifTrue: [ ^ self onMethodRemoved: aMethodRecategorized methodRecategorized ].
]

{ #category : #'private - event handling' }
GtPharoBehaviorProtocolCoder >> onSystemMethodRemoved: aMethodRemoved [
	aMethodRemoved protocol = self protocol
		ifTrue: [ self onMethodRemoved: aMethodRemoved methodRemoved ]
]

{ #category : #accessing }
GtPharoBehaviorProtocolCoder >> protocol [
	<return: #String>

	^ protocol
]

{ #category : #accessing }
GtPharoBehaviorProtocolCoder >> protocolBehavior [
	^ protocolBehavior
]

{ #category : #'private - subscriptions' }
GtPharoBehaviorProtocolCoder >> subscribeToSystem [
	self unsubscribeFromSystem.

	SystemAnnouncer uniqueInstance weak
		when: ClassAdded send: #onClassAdded: to: self;
		when: ClassRenamed send: #onClassRenamed: to: self;
		when: ClassRemoved send: #onClassRemoved: to: self;
		when: MethodAdded send: #onSystemMethodAdded: to: self;
		when: MethodRemoved send: #onSystemMethodRemoved: to: self;
		when: MethodModified send: #onSystemMethodModified: to: self;
		when: MethodRecategorized send: #onSystemMethodRecategorized: to: self
]
