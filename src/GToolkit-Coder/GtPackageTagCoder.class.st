Class {
	#name : #GtPackageTagCoder,
	#superclass : #Announcer,
	#instVars : [
		'packageTag',
		'packageCoder',
		'classesCoder'
	],
	#category : #'GToolkit-Coder-Coders'
}

{ #category : #'instance creation' }
GtPackageTagCoder class >> forPackageTag: aPackageTag [
	^ self new
		packageTag: aPackageTag;
		yourself
]

{ #category : #converting }
GtPackageTagCoder >> asCardElement [
	^ GtPackageTagCardElement new coder: self
]

{ #category : #element }
GtPackageTagCoder >> asElement [
	^ GtPackageTagCoderElement new packageTagCoder: self
]

{ #category : #accessing }
GtPackageTagCoder >> classesCoder [
	^ classesCoder
		ifNil: [ classesCoder := GtClassesCoder new.
			packageTag notNil
				ifTrue: [ classesCoder forPackageTag: packageTag ].
			classesCoder ]
]

{ #category : #accessing }
GtPackageTagCoder >> coderForClass: aClass [
	^ packageCoder coderForClass: aClass
]

{ #category : #accessing }
GtPackageTagCoder >> coders [
	^ self classesCoder coders
]

{ #category : #ui }
GtPackageTagCoder >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Package Tag';
		priority: 1;
		stencil: [ self ];
		actionButtonIcon: BrGlamorousIcons inspect
			action: [ :aButton | aButton phlow spawnObject: self packageTag ]
]

{ #category : #accessing }
GtPackageTagCoder >> icon [
	^ BrGlamorousIcons packageicon asElement
]

{ #category : #accessing }
GtPackageTagCoder >> name [
	^ packageTag name
]

{ #category : #accessing }
GtPackageTagCoder >> package [
	^ packageTag package
]

{ #category : #accessing }
GtPackageTagCoder >> packageCoder [
	^ packageCoder
]

{ #category : #accessing }
GtPackageTagCoder >> packageCoder: aPackageCoder [
	packageCoder := aPackageCoder
]

{ #category : #accessing }
GtPackageTagCoder >> packageTag [
	^ packageTag
]

{ #category : #accessing }
GtPackageTagCoder >> packageTag: anObject [
	packageTag := anObject
]
