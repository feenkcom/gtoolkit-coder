"
I am the entrance point into the coder as a tool
"
Class {
	#name : #GtCoder,
	#superclass : #BlElement,
	#instVars : [
		'coderContent'
	],
	#category : #'GToolkit-Coder-! Core'
}

{ #category : #'instance creation' }
GtCoder class >> forCoder: aCoder [
	^ self basicNew initialize pushCoder: aCoder
]

{ #category : #'instance creation' }
GtCoder class >> new [
	^ self forCoder: GtPackagesCoder new
]

{ #category : #initialization }
GtCoder >> initialize [
	super initialize.
	
	self
		when: GtCoderToReplace
		do: [ :anEvent | self replaceFrom: anEvent ].

	self
		when: GtCoderToSpawn
		do: [ :anEvent | self spawnFrom: anEvent ].

	self
		when: GtCoderToSpawnInSpace
		do: [ :anEvent | self spawnInSpaceFrom: anEvent ].

	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
		
	coderContent := BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].

	self addChild: coderContent
]

{ #category : #'api - coder' }
GtCoder >> pushCoder: aCoderOrCoders [
	coderContent removeChildren.
	coderContent addChild: aCoderOrCoders asElement
]

{ #category : #'api - spawning' }
GtCoder >> replaceFrom: aGtCoderToReplaceEvent [
	aGtCoderToReplaceEvent consumed: true.
	
	self pushCoder: aGtCoderToReplaceEvent coder
]

{ #category : #'api - spawning' }
GtCoder >> spawnFrom: aGtCoderToSpawnEvent [
	aGtCoderToSpawnEvent consumed: true.
	
	self phlow spawnObject: (self class forCoder: aGtCoderToSpawnEvent coder)
]

{ #category : #'api - spawning' }
GtCoder >> spawnInSpaceFrom: aGtCoderToSpawnInSpaceEvent [
	aGtCoderToSpawnInSpaceEvent consumed: true.
	
	
]
