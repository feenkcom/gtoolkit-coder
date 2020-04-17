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
		
	self addChild: coderContent.
	self pushCoder: GtPackagesCoder new
]

{ #category : #'api - coder' }
GtCoder >> pushCoder: aCoderOrCoders [
	coderContent removeChildren.
	coderContent addChild: aCoderOrCoders asElement
]

{ #category : #'api - spawning' }
GtCoder >> replaceFrom: aGtCoderToReplaceEvent [
	aGtCoderToReplaceEvent consumed: true.
	
	
]

{ #category : #'api - spawning' }
GtCoder >> spawnFrom: aGtCoderToSpawnEvent [
	aGtCoderToSpawnEvent consumed: true.
	
	
]

{ #category : #'api - spawning' }
GtCoder >> spawnInSpaceFrom: aGtCoderToSpawnInSpaceEvent [
	aGtCoderToSpawnInSpaceEvent consumed: true.
	
	
]
