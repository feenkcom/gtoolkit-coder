Class {
	#name : #GtPackagesCoder,
	#superclass : #GtCoders,
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #accessing }
GtPackagesCoder >> coderForClass: aClass [
	^ (self coderForPackage: aClass package)
		ifNotNil: [ :coder | coder coderForClass: aClass ]
]

{ #category : #accessing }
GtPackagesCoder >> coderForPackage: aPackage [
	^ self coders
		detect: [ :each | each package = aPackage ]
		ifNone: [ | coder |
			items add: aPackage.
			coder := self newCoderFor: aPackage.
			coders add: coder.
			coder ]
]

{ #category : #elements }
GtPackagesCoder >> elementClass [
	^ GtPackagesCoderElement
]

{ #category : #'initialize-release' }
GtPackagesCoder >> initialize [
	super initialize.
	self
		forItems:
			(RPackageOrganizer default packages
				asSortedCollection: [ :a :b | a name < b name ])
]

{ #category : #accessing }
GtPackagesCoder >> name [
	^ 'Pharo'
]

{ #category : #private }
GtPackagesCoder >> newCoderFor: anObject [
	^ GtPackageCoder new package: anObject
]

{ #category : #accessing }
GtPackagesCoder >> packageTreeCoders [
	^ self coders
]

{ #category : #scripting }
GtPackagesCoder >> withClass: aClass [
  self announce: (GtPackagesCoderNavigationAnnouncement new coder: (self coderForClass: aClass))
]

{ #category : #scripting }
GtPackagesCoder >> withPackage: aPackage [
  self announce: (GtPackagesCoderNavigationAnnouncement new coder: (self coderForPackage: aPackage))
]

{ #category : #scripting }
GtPackagesCoder >> withSelectedMethod: aCompiledMethod [
	| coder |
	coder := self coderForClass: aCompiledMethod methodClass.
	self withClass: aCompiledMethod methodClass.
	coder withSelectedMethod: aCompiledMethod
]
