Class {
	#name : #GtPackagesCoder,
	#superclass : #GtCodersModel,
	#traits : 'TGtCoderTrait',
	#classTraits : 'TGtCoderTrait classTrait',
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #comparing }
GtPackagesCoder >> = anObject [
	^ self class = anObject class
]

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

{ #category : #comparing }
GtPackagesCoder >> hash [
	^ self class hash
]

{ #category : #accessing }
GtPackagesCoder >> icon [
	^ BrGlamorousIcons packageicon asElement
]

{ #category : #'initialize-release' }
GtPackagesCoder >> initialize [
	super initialize.

	self forItems: (RPackageOrganizer default packages asSortedCollection: [ :a :b | a name < b name ])
]

{ #category : #accessing }
GtPackagesCoder >> name [
	^ 'Pharo'
]

{ #category : #private }
GtPackagesCoder >> newCoderFor: aPackage [
	^ GtPackageCoder forPackage: aPackage
]
