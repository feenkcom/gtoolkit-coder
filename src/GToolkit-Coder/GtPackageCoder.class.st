Class {
	#name : #GtPackageCoder,
	#superclass : #GtCoderModel,
	#traits : 'TGtCoderTrait',
	#classTraits : 'TGtCoderTrait classTrait',
	#instVars : [
		'package',
		'packageTagCoders',
		'classesCoder'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtPackageCoder class >> forPackage: anRPackage [
	^ self new
		package: anRPackage;
		yourself
]

{ #category : #'private - adding / removing' }
GtPackageCoder >> addMissingPackageTag: aPackageTag [
	<return: #GtPackageTagCoder>
	| aCoder |
	aCoder := self newPackageTagCoderFor: aPackageTag.
	self packageTagCoders add: aCoder.
	^ aCoder
]

{ #category : #accessing }
GtPackageCoder >> classes [
	^ self package classes
]

{ #category : #accessing }
GtPackageCoder >> classesCoder [
	<return: #GtClassesCoder>

	^ classesCoder
		ifNil: [
			classesCoder := GtClassesCoder new.
			classesCoder forPackage: self package.
			classesCoder ]
]

{ #category : #accessing }
GtPackageCoder >> coderForClass: aClass [
	^ self classesCoder coderForClass: aClass
]

{ #category : #accessing }
GtPackageCoder >> coders [
	^ self classesCoder coders
]

{ #category : #accessing }
GtPackageCoder >> icon [
	^ BrGlamorousIcons packageicon asElement
]

{ #category : #testing }
GtPackageCoder >> isForPackage [
	^ true
]

{ #category : #testing }
GtPackageCoder >> isRegistered [
	"Return true if the package is registered in the system, false otherwise"
	<return: #Boolean>
	
	^ self package organizer includesPackage: self package
]

{ #category : #accessing }
GtPackageCoder >> name [
	^ package name
]

{ #category : #'private - instance creation' }
GtPackageCoder >> newPackageTagCoderFor: aPackageTag [
	^ GtPackageTagCoder new
		packageTag: aPackageTag;
		packageCoder: self;
		yourself
]

{ #category : #'private - instance creation' }
GtPackageCoder >> newPackageTagCoders [
	^ (package classTags
			collect: [ :eachTag | self newPackageTagCoderFor: eachTag ])
				asSortedCollection: [ :a :b | a name < b name ]
]

{ #category : #'private - notifying' }
GtPackageCoder >> notifyPackageRegistered [
	self announce: (GtCoderPackageRegistered new coder: self)
]

{ #category : #'private - notifying' }
GtPackageCoder >> notifyPackageRenamed [
	self announce: (GtCoderPackageRenamed new coder: self)
]

{ #category : #'private - notifying' }
GtPackageCoder >> notifyPackageUnregistered [
	self announce: (GtCoderPackageUnregistered new coder: self)
]

{ #category : #'event handling' }
GtPackageCoder >> onPackageRegistered: anAnnouncement [
	anAnnouncement package name = self name
		ifFalse: [ ^ self ].
		
	self notifyPackageRegistered
]

{ #category : #'event handling' }
GtPackageCoder >> onPackageRenamed: anAnnouncement [
	anAnnouncement oldName = self name
		ifFalse: [ ^ self ].
	
	self notifyPackageRenamed
]

{ #category : #'event handling' }
GtPackageCoder >> onPackageUnregistered: anAnnouncement [
	anAnnouncement package name = self name
		ifFalse: [ ^ self ].
		
	self notifyPackageUnregistered
]

{ #category : #accessing }
GtPackageCoder >> package [
	<return: #RPackage>

	^ package
]

{ #category : #accessing }
GtPackageCoder >> package: aRPackage [
	self
		assert: [ aRPackage notNil ]
		description: [ 'Package must not be nil' ].

	package := aRPackage.
	classesCoder ifNotNil: [ :aClassesCoder | aClassesCoder forPackage: aRPackage ]
]

{ #category : #accessing }
GtPackageCoder >> packageTagCoderFor: aPackageTag [
	^ self packageTagCoders
		detect: [ :each | each packageTag = aPackageTag ]
		ifNone: [ self addMissingPackageTag: aPackageTag ]
]

{ #category : #accessing }
GtPackageCoder >> packageTagCoders [
	^ packageTagCoders
		ifNil:
			[ packageTagCoders := self newPackageTagCoders ]
]

{ #category : #accessing }
GtPackageCoder >> packageTagForClass: aClass [
	^ (package classTagForClass: aClass)
		ifNotNil: [ :tag | 
			self packageTagCoders
				detect: [ :each | each packageTag = tag ]
				ifNone: [  ] ]
]

{ #category : #accessing }
GtPackageCoder >> packageTreeCoders [
	^ self coders
]

{ #category : #'api - actions' }
GtPackageCoder >> register [
	"Register a package in the system, and announce ${class:GtCoderPackageRegistered}$ if it was registered"	
	self isRegistered
		ifTrue: [ ^ self ].

	self announcer
		suppress: GtCoderPackageRegistered
		during: [ self package register ].
		
	self notifyPackageRegistered
]

{ #category : #'api - actions' }
GtPackageCoder >> renameTo: aNewPackageName [

	self isRegistered
		ifFalse: [
			self package name: aNewPackageName.
			^ self notifyPackageRenamed ].

	self announcer
		suppress: GtCoderPackageRenamed
		during: [ self package renameTo: aNewPackageName ].

	self notifyPackageRenamed
]

{ #category : #subscriptions }
GtPackageCoder >> subscribeToSystem [	
	SystemAnnouncer uniqueInstance weak
		when: RPackageRegistered send: #onPackageRegistered: to: self;
		when: RPackageRenamed send: #onPackageRenamed: to: self;
		when: RPackageUnregistered send: #onPackageUnregistered: to: self
]

{ #category : #'api - actions' }
GtPackageCoder >> unload [
	"Remove package from the system including all defined classes and extension methods"
	| wasRegistered |

	wasRegistered := self isRegistered.

	self announcer
		suppress: GtCoderPackageUnregistered
		during: [ self package removeFromSystem ].

	"only notify if it was registered and now it is not longer the case"
	(wasRegistered and: [ self isRegistered not ])
		ifTrue: [ self notifyPackageUnregistered ]
]

{ #category : #'api - actions' }
GtPackageCoder >> unregister [
	"Register a package in the system, and announce ${class:GtCoderPackageUnregistered}$ if it was unregistered.
	Unregistering a package does not remove its classes (quite dangerous!)"	
	self isRegistered
		ifFalse: [ ^ self ].

	self announcer
		suppress: GtCoderPackageUnregistered
		during: [ self package unregister ].

	self notifyPackageUnregistered
]
