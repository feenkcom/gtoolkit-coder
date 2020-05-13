Class {
	#name : #GtPackageCoder,
	#superclass : #Announcer,
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

{ #category : #elements }
GtPackageCoder >> asCardElement [
	^ GtPackageCardElement new coder: self
]

{ #category : #elements }
GtPackageCoder >> asElement [
	^ GtPackageCoderElement new packageCoder: self
]

{ #category : #accessing }
GtPackageCoder >> classesCoder [
	^ classesCoder
		ifNil: [ classesCoder := GtClassesCoder new.
			package notNil
				ifTrue: [ classesCoder forPackage: package ].
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

{ #category : #ui }
GtPackageCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Package';
		priority: 1;
		stencil: [ self ];
		actionButtonIcon: BrGlamorousVectorIcons inspect
			action: [ :aButton | aButton phlow spawnObject: self package withTool: GtPackageCoderTool new ]
]

{ #category : #accessing }
GtPackageCoder >> icon [
	^ BrGlamorousIcons packageicon asElement
]

{ #category : #testing }
GtPackageCoder >> isForPackage [
	^ true
]

{ #category : #accessing }
GtPackageCoder >> name [
	^ package name
]

{ #category : #accessing }
GtPackageCoder >> package [
	^ package
]

{ #category : #accessing }
GtPackageCoder >> package: aRPackage [
	package := aRPackage.
	classesCoder notNil
		ifTrue: [ classesCoder forPackage: aRPackage ]
]

{ #category : #accessing }
GtPackageCoder >> packageTagCoderFor: aPackageTag [
	^ self packageTagCoders
		detect: [ :each | each packageTag = aPackageTag ]
		ifNone: [  ]
]

{ #category : #accessing }
GtPackageCoder >> packageTagCoders [
	^ packageTagCoders
		ifNil: [ packageTagCoders := (package classTags
				collect: [ :each | 
					GtPackageTagCoder new
						packageTag: each;
						packageCoder: self;
						yourself ]) asSortedCollection: [ :a :b | a name < b name ] ]
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
