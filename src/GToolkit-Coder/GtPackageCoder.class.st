Class {
	#name : #GtPackageCoder,
	#superclass : #GtCoderModel,
	#traits : 'TGtCoderTrait',
	#classTraits : 'TGtCoderTrait classTrait',
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #testing }
GtPackageCoder >> isForPackage [
	^ true
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

{ #category : #'private - actions' }
GtPackageCoder >> primitiveRegisterPackage [
	self subclassResponsibility
]

{ #category : #'private - actions' }
GtPackageCoder >> primitiveRemovePackage [
	self subclassResponsibility
]

{ #category : #'private - actions' }
GtPackageCoder >> primitiveRenamePackageTo: aNewPackageName [
	self subclassResponsibility
]

{ #category : #'private - actions' }
GtPackageCoder >> primitiveUnregisterPackage [
	self subclassResponsibility
]

{ #category : #'api - actions' }
GtPackageCoder >> register [
	"Register a package in the system, and announce ${class:GtCoderPackageRegistered}$ if it was registered"	
	self isRegistered
		ifTrue: [ ^ self ].

	self announcer
		suppress: GtCoderPackageRegistered
		during: [ self primitiveRegisterPackage ].

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
		during: [ self primitiveRenamePackageTo: aNewPackageName ].

	self notifyPackageRenamed
]

{ #category : #'api - actions' }
GtPackageCoder >> unload [
	"Remove package from the system including all defined classes and extension methods"
	| wasRegistered |

	wasRegistered := self isRegistered.

	self announcer
		suppress: GtCoderPackageUnregistered
		during: [ self primitiveRemovePackage ].

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
		during: [ self primitiveUnregisterPackage ].

	self notifyPackageUnregistered
]
