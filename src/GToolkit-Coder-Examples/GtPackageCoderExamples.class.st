Class {
	#name : #GtPackageCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Coders'
}

{ #category : #'private - set up' }
GtPackageCoderExamples >> addFakeClassesToPackage: aPackage [
	self fakeClassNames do: [ :eachClassName |
		Object subclass: eachClassName
			instanceVariableNames: ''
			classVariableNames: ''
			package: aPackage name ]
]

{ #category : #'private - set up' }
GtPackageCoderExamples >> cleanUp [
	self fakeClassNames do: [ :eachClassName |
		self class environment
			at: eachClassName
			ifPresent: [ :eachClass | eachClass removeFromSystem ] ].

	(RPackageOrganizer default
		packageNamed: self fakePackageName
		ifAbsent: [ nil ]) ifNotNil: #removeFromSystem.

	(RPackageOrganizer default
		packageNamed: self renamedFakePackageName
		ifAbsent: [ nil ]) ifNotNil: #removeFromSystem
]

{ #category : #'examples - instance creation' }
GtPackageCoderExamples >> coderOnRegisteredPackage [
	<gtExample>
	<after: #cleanUp>
	| aPackage aPackageCoder |

	aPackage := self fakeRegisteredPackage.
	aPackageCoder := GtPackageCoder forPackage: aPackage.

	self assert: aPackageCoder package equals: aPackage.
	self assert: aPackageCoder name equals: aPackage name.
	self assert: aPackageCoder isRegistered.
	self assert: aPackageCoder classes size equals: self fakeClassCount.
	self assert: self fakeClassInSystemCount equals: self fakeClassCount.

	^ aPackageCoder
]

{ #category : #'examples - instance creation' }
GtPackageCoderExamples >> coderOnUnregisteredPackage [
	<gtExample>
	<after: #cleanUp>
	| aPackage aPackageCoder |

	aPackage := self fakeUnregisteredPackage.
	aPackageCoder := GtPackageCoder forPackage: aPackage.
	
	self assert: aPackageCoder package equals: aPackage.
	self assert: aPackageCoder name equals: aPackage name.
	self assert: aPackageCoder isRegistered not.
	self assert: aPackageCoder classes size equals: 0.

	^ aPackageCoder
]

{ #category : #'private - set up' }
GtPackageCoderExamples >> eventsRecorder [
	^ GtCoderExamplesEventsRecorder new
]

{ #category : #'private - set up' }
GtPackageCoderExamples >> fakeClassCount [
	^ 2
]

{ #category : #'private - set up' }
GtPackageCoderExamples >> fakeClassInSystemCount [
	^ (self fakeClassNames select: [ :eachClassName |
		self class environment
			at: eachClassName
			ifPresent: [ true ]
			ifAbsent: [ false ] ]) size
]

{ #category : #'private - set up' }
GtPackageCoderExamples >> fakeClassNames [
	<script: 'self new fakeClassNames inspect'>
	| aPackageName |
	
	aPackageName := self fakePackageName.
	
	^ (1 to: self fakeClassCount) collect: [ :index | (aPackageName asCamelCase asValidSelector capitalized, 'Class', index asString) asSymbol ]
]

{ #category : #'private - set up' }
GtPackageCoderExamples >> fakePackageName [
	^ 'PackageCoderTemporary' asSymbol
]

{ #category : #'private - set up' }
GtPackageCoderExamples >> fakeRegisteredPackage [
	| aFakePackageName aPackage |
	
	self cleanUp.

	aFakePackageName := self fakePackageName.
	
	self assert: (RPackageOrganizer default includesPackageNamed: aFakePackageName) not.
	
	aPackage := RPackageOrganizer default createPackageNamed: aFakePackageName.
	
	self addFakeClassesToPackage: aPackage.
	
	^ aPackage
]

{ #category : #'private - set up' }
GtPackageCoderExamples >> fakeUnregisteredPackage [
	| aFakePackageName aPackage |

	self cleanUp.
	
	aFakePackageName := self fakePackageName.
	
	self assert: (RPackageOrganizer default includesPackageNamed: aFakePackageName) not.
	
	aPackage := RPackageOrganizer default packageClass named: aFakePackageName.
	
	^ aPackage
]

{ #category : #'examples - package register' }
GtPackageCoderExamples >> registerPreviouslyUnregisteredPackageWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aPackageCoder := self unregisterRegisteredPackageWhenSubscribedToSystem.
	aPackageCoder subscribeToSystem.
	
	aPackageCoder when: GtCoderPackageRegistered send: #record: to: anEventsRecoder.

	[ aPackageCoder register ] ensure: [
		aPackageCoder unsubscribeFromSystem ].

	self assert: aPackageCoder isRegistered.
	self assert: aPackageCoder classes size equals: self fakeClassCount.
	self assert: self fakeClassInSystemCount equals: self fakeClassCount.
	"When registering previously unregistered package, its classes are moved back from the unpackaged package to the package itself"
	self assert: (aPackageCoder classes collect: [ :each | each package ]) asSet equals: {  aPackageCoder package } asSet. 

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageRegistered.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'examples - package register' }
GtPackageCoderExamples >> registerRegisteredPackageWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aPackageCoder := self coderOnRegisteredPackage.
	aPackageCoder subscribeToSystem.
	
	aPackageCoder when: GtCoderPackageRegistered send: #record: to: anEventsRecoder.

	[ aPackageCoder register ] ensure: [
		aPackageCoder unsubscribeFromSystem ].

	self assert: aPackageCoder isRegistered.
	self assert: anEventsRecoder numberOfEvents equals: 0.
	
	^ aPackageCoder
]

{ #category : #'examples - package register' }
GtPackageCoderExamples >> registerRegisteredPackageWhenUnsubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aPackageCoder := self coderOnRegisteredPackage.
	
	aPackageCoder when: GtCoderPackageRegistered send: #record: to: anEventsRecoder.

	aPackageCoder register.

	self assert: aPackageCoder isRegistered.
	self assert: anEventsRecoder numberOfEvents equals: 0.
	
	^ aPackageCoder
]

{ #category : #'examples - package register' }
GtPackageCoderExamples >> registerUnregisteredPackageWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aPackageCoder := self coderOnUnregisteredPackage.
	aPackageCoder subscribeToSystem.
	
	aPackageCoder when: GtCoderPackageRegistered send: #record: to: anEventsRecoder.

	[ aPackageCoder register ] ensure: [
		aPackageCoder unsubscribeFromSystem ].

	self assert: aPackageCoder isRegistered.
	self assert: aPackageCoder classes size equals: 0.
	self assert: self fakeClassInSystemCount equals: 0.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageRegistered.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'examples - package register' }
GtPackageCoderExamples >> registerUnregisteredPackageWhenUnsubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aPackageCoder := self coderOnUnregisteredPackage.
	
	aPackageCoder when: GtCoderPackageRegistered send: #record: to: anEventsRecoder.

	aPackageCoder register.

	self assert: aPackageCoder isRegistered.
	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageRegistered.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'examples - package register' }
GtPackageCoderExamples >> registerUnregisteredPackageWithoutCoderWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aPackageCoder := self coderOnUnregisteredPackage.
	aPackageCoder subscribeToSystem.

	aPackageCoder when: GtCoderPackageRegistered send: #record: to: anEventsRecoder.

	[ aPackageCoder package register ] ensure: [
		aPackageCoder unsubscribeFromSystem ].

	self assert: aPackageCoder isRegistered.
	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageRegistered.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'examples - package register' }
GtPackageCoderExamples >> registerUnregisteredPackageWithoutCoderWhenUnsubscribedToSystem [
	"The only case when we can not send package registered notification
	is when coder is not subscribed to the system and package is registered directly,
	without coder being involved"
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aPackageCoder := self coderOnUnregisteredPackage.
	aPackageCoder when: GtCoderPackageRegistered send: #record: to: anEventsRecoder.

	aPackageCoder package register.

	self assert: aPackageCoder isRegistered.
	self assert: anEventsRecoder numberOfEvents equals: 0.
	
	^ aPackageCoder
]

{ #category : #'examples - package rename' }
GtPackageCoderExamples >> renameRegisteredPackageWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aPackageCoder := self coderOnRegisteredPackage.
	aPackageCoder subscribeToSystem.

	aPackageCoder when: GtCoderPackageRenamed send: #record: to: anEventsRecoder.

	[ aPackageCoder renameTo: self renamedFakePackageName ] ensure: [
		aPackageCoder unsubscribeFromSystem ].

	self assert: aPackageCoder isRegistered.
	self assert: aPackageCoder name equals: self renamedFakePackageName.
	self assert: aPackageCoder classes size equals: self fakeClassCount.
	self assert: self fakeClassInSystemCount equals: self fakeClassCount.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageRenamed.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'examples - package rename' }
GtPackageCoderExamples >> renameUnloadedPackageWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aPackageCoder := self unloadRegisteredPackageWhenSubscribedToSystem.
	aPackageCoder subscribeToSystem.

	aPackageCoder when: GtCoderPackageRenamed send: #record: to: anEventsRecoder.

	[ aPackageCoder renameTo: self renamedFakePackageName ] ensure: [
		aPackageCoder unsubscribeFromSystem ].

	self assert: aPackageCoder isRegistered not.
	self assert: aPackageCoder name equals: self renamedFakePackageName.
	self assert: aPackageCoder classes size equals: 0.
	self assert: self fakeClassInSystemCount equals: 0.
	
	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageRenamed.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'examples - package rename' }
GtPackageCoderExamples >> renameUnregisteredPackageWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aPackageCoder := self coderOnUnregisteredPackage.
	aPackageCoder subscribeToSystem.

	aPackageCoder when: GtCoderPackageRenamed send: #record: to: anEventsRecoder.

	[ aPackageCoder renameTo: self renamedFakePackageName ] ensure: [
		aPackageCoder unsubscribeFromSystem ].

	self assert: aPackageCoder isRegistered not.
	self assert: aPackageCoder name equals: self renamedFakePackageName.
	self assert: aPackageCoder classes size equals: 0.
	self assert: self fakeClassInSystemCount equals: 0.

	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageRenamed.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'examples - package rename' }
GtPackageCoderExamples >> renameUnregisteredRegisteredPackageWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aPackageCoder := self unregisterRegisteredPackageWhenSubscribedToSystem.
	aPackageCoder subscribeToSystem.

	aPackageCoder when: GtCoderPackageRenamed send: #record: to: anEventsRecoder.

	[ aPackageCoder renameTo: self renamedFakePackageName ] ensure: [
		aPackageCoder unsubscribeFromSystem ].

	self assert: aPackageCoder isRegistered not.
	self assert: aPackageCoder name equals: self renamedFakePackageName.
	self assert: aPackageCoder classes size equals: self fakeClassCount.
	self assert: self fakeClassInSystemCount equals: self fakeClassCount.
	
	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageRenamed.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'private - set up' }
GtPackageCoderExamples >> renamedFakePackageName [
	^ (self fakePackageName, 'Renamed') asSymbol
]

{ #category : #'examples - package unload' }
GtPackageCoderExamples >> unloadRegisteredPackageWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aPackageCoder := self coderOnRegisteredPackage.
	aPackageCoder subscribeToSystem.

	aPackageCoder when: GtCoderPackageUnregistered send: #record: to: anEventsRecoder.

	[ aPackageCoder unload ] ensure: [
		aPackageCoder unsubscribeFromSystem ].

	self assert: aPackageCoder isRegistered not.
	"classes are removed from the system when unloading a package"
	self assert: aPackageCoder classes size equals: 0.
	self assert: self fakeClassInSystemCount equals: 0.
	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageUnregistered.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'examples - package unload' }
GtPackageCoderExamples >> unloadRegisteredPackageWhenUnsubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |

	anEventsRecoder := self eventsRecorder.

	aPackageCoder := self coderOnRegisteredPackage.
	aPackageCoder when: GtCoderPackageUnregistered send: #record: to: anEventsRecoder.

	aPackageCoder unload.

	self assert: aPackageCoder isRegistered not.
	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageUnregistered.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'examples - package unregister' }
GtPackageCoderExamples >> unregisterRegisteredPackageWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aPackageCoder := self coderOnRegisteredPackage.
	aPackageCoder subscribeToSystem.

	aPackageCoder when: GtCoderPackageUnregistered send: #record: to: anEventsRecoder.

	[ aPackageCoder unregister ] ensure: [
		aPackageCoder unsubscribeFromSystem ].

	self assert: aPackageCoder isRegistered not.
	"classes are not removed from the system when unregistering package"
	self assert: aPackageCoder classes size equals: self fakeClassCount.
	self assert: self fakeClassInSystemCount equals: self fakeClassCount.
	
	"When unregistering a package with classes, those classes are moved to unpackaged package"
	self assert: (aPackageCoder classes collect: [ :each | each package name ]) asSet equals: { #'_UnpackagedPackage' } asSet. 
	
	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageUnregistered.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'examples - package unregister' }
GtPackageCoderExamples >> unregisterRegisteredPackageWhenUnsubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aPackageCoder := self coderOnRegisteredPackage.
	aPackageCoder when: GtCoderPackageUnregistered send: #record: to: anEventsRecoder.

	aPackageCoder unregister.

	self assert: aPackageCoder isRegistered not.
	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageUnregistered.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'examples - package unregister' }
GtPackageCoderExamples >> unregisterRegisteredPackageWithoutCoderWhenSubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aPackageCoder := self coderOnRegisteredPackage.
	aPackageCoder subscribeToSystem.

	aPackageCoder when: GtCoderPackageUnregistered send: #record: to: anEventsRecoder.

	[ aPackageCoder package unregister ] ensure: [
		aPackageCoder unsubscribeFromSystem ].

	self assert: aPackageCoder isRegistered not.
	self assert: anEventsRecoder numberOfEvents equals: 1.
	self assert: anEventsRecoder first class equals: GtCoderPackageUnregistered.
	self assert: anEventsRecoder first coder equals: aPackageCoder.
	
	^ aPackageCoder
]

{ #category : #'examples - package unregister' }
GtPackageCoderExamples >> unregisterRegisteredPackageWithoutCoderWhenUnsubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aPackageCoder := self coderOnRegisteredPackage.
	aPackageCoder when: GtCoderPackageUnregistered send: #record: to: anEventsRecoder.

	aPackageCoder package unregister.

	self assert: aPackageCoder isRegistered not.
	self assert: anEventsRecoder numberOfEvents equals: 0.
	
	^ aPackageCoder
]

{ #category : #'examples - package unregister' }
GtPackageCoderExamples >> unregisterUnregisteredPackageWhenUnsubscribedToSystem [
	<gtExample>
	<after: #cleanUp>
	| aPackageCoder anEventsRecoder |
	
	anEventsRecoder := self eventsRecorder.
	
	aPackageCoder := self coderOnUnregisteredPackage.
	aPackageCoder when: GtCoderPackageUnregistered send: #record: to: anEventsRecoder.

	aPackageCoder unregister.

	self assert: aPackageCoder isRegistered not.
	self assert: anEventsRecoder numberOfEvents equals: 0.
	
	^ aPackageCoder
]
