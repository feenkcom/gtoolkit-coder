"
I am an abstract class.
I am an {{gtClass:BlElement}}.
I provide basic {{gtClass:TBrLayoutResizable}} methods.
See my {{gtClass:GtCoderElement|expanded|show=#gtSubclassesFor:}} for concrete implementations:


"
Class {
	#name : #GtAbstractCoderElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'navigationModel'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'private - asserting' }
GtAbstractCoderElement >> assertNavigationModel: aGtCoderNavigationModel [
	self 
		assert: [ aGtCoderNavigationModel isNotNil ] 
		description: [ 'Navigation model must be non-nil' ].
	self 
		assert: [ aGtCoderNavigationModel ~= GtCoderNavigationModel null ] 
		description: [ 'Navigation model must be different from ', GtCoderNavigationModel null className ].
	
]

{ #category : #defaults }
GtAbstractCoderElement >> defaultNavigationModel [
	^ GtCoderNavigationModel null
]

{ #category : #initialization }
GtAbstractCoderElement >> initialize [
	super initialize.
	self matchParent.
	navigationModel := self defaultNavigationModel.
	self initializeListeners
]

{ #category : #initialization }
GtAbstractCoderElement >> initializeListeners [
	self
		when: GtCoderToReplace
		do: [ :anEvent | self replaceFrom: anEvent ].

	self
		when: GtCoderToSpawn
		do: [ :anEvent | self spawnFrom: anEvent ].
		
	self
		when: GtCoderToSpawnInSpace
		do: [ :anEvent | self spawnInSpaceFrom: anEvent ].
]

{ #category : #'api - accessing' }
GtAbstractCoderElement >> navigationModel [
	<return: #GtCoderNavigationModel>
	^ navigationModel
]

{ #category : #'api - accessing' }
GtAbstractCoderElement >> navigationModel: aGtCoderNavigationModel [
	navigationModel = aGtCoderNavigationModel ifTrue: [  ^ self ].
	self unsubscribeFromNavigationModel.
	navigationModel := aGtCoderNavigationModel.
	self subscribeToNavigationModel.
	self onNavigationModelChanged.
]

{ #category : #'private - hooks' }
GtAbstractCoderElement >> onNavigationModelChanged [
	"Subclasses can react to navigation model changes."
]

{ #category : #'api - updating' }
GtAbstractCoderElement >> pushCoder: aCoderOrCoders [
	self navigationModel selectCoder: aCoderOrCoders
]

{ #category : #'private - event handling' }
GtAbstractCoderElement >> replaceFrom: aGtCoderToReplaceEvent [
	aGtCoderToReplaceEvent consumed: true.
	
	self pushCoder: aGtCoderToReplaceEvent coder
]

{ #category : #'private - event handling' }
GtAbstractCoderElement >> spawnFrom: aGtCoderToSpawnEvent [
	aGtCoderToSpawnEvent consumed: true.
	
	self phlow spawnTool: (GtReadyCoderTool coder: (aGtCoderToSpawnEvent coder))
]

{ #category : #'private - event handling' }
GtAbstractCoderElement >> spawnInSpaceFrom: aGtCoderToSpawnInSpaceEvent [
	aGtCoderToSpawnInSpaceEvent consumed: true.
]

{ #category : #'private - subscriptions' }
GtAbstractCoderElement >> subscribeToNavigationModel [
	"Subclasses can subscribe to the navigation model"
]

{ #category : #'private - subscriptions' }
GtAbstractCoderElement >> unsubscribeFromNavigationModel [
	self navigationModel = GtCoderNavigationModel null ifTrue: [ ^ self ].
	self navigationModel unsubscribe: self.
]
