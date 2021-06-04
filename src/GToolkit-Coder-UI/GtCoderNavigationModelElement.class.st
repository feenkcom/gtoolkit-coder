"
I am an abstract class.
I provide basic {{gtMethod:GtCoderNavigationModelElement>>#navigationModel:|label=navigation}} accessors, model {{gtMethod:GtCoderNavigationModelElement>>#subscribeToNavigationModel|label=subscriptons}}, and model {{gtMethod:GtCoderNavigationModelElement>>#onNavigationModelChanged|label=instance changes}}.
See my {{gtClass:GtCoderNavigationModelElement|expanded|show=#gtSubclassesFor:}} for concrete implementations:


"
Class {
	#name : #GtCoderNavigationModelElement,
	#superclass : #GtCoderElement,
	#instVars : [
		'navigationModel'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'private - asserting' }
GtCoderNavigationModelElement >> assertNavigationModel: aGtCoderNavigationModel [
	self 
		assert: [ aGtCoderNavigationModel isNotNil ] 
		description: [ 'Navigation model must be non-nil' ].
	self 
		assert: [ aGtCoderNavigationModel ~= GtCoderNavigationModel null ] 
		description: [ 'Navigation model must be different from ', GtCoderNavigationModel null className ].
	
]

{ #category : #defaults }
GtCoderNavigationModelElement >> defaultNavigationModel [
	^ GtCoderNavigationModel null
]

{ #category : #initialization }
GtCoderNavigationModelElement >> initialize [
	super initialize.
	navigationModel := self defaultNavigationModel.
	self initializeListeners.

]

{ #category : #initialization }
GtCoderNavigationModelElement >> initializeListeners [
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
GtCoderNavigationModelElement >> navigationModel [
	<return: #GtCoderNavigationModel>
	^ navigationModel
]

{ #category : #'api - accessing' }
GtCoderNavigationModelElement >> navigationModel: aGtCoderNavigationModel [
	navigationModel = aGtCoderNavigationModel ifTrue: [  ^ self ].
	self assertNavigationModel: aGtCoderNavigationModel.
	self unsubscribeFromNavigationModel.
	navigationModel := aGtCoderNavigationModel.
	self subscribeToNavigationModel.
	self onNavigationModelChanged.
]

{ #category : #'private - hooks' }
GtCoderNavigationModelElement >> onNavigationModelChanged [
	"Subclasses can react to navigation model changes."
]

{ #category : #'api - updating' }
GtCoderNavigationModelElement >> pushCoder: aCoderOrCoders [
	self assertNavigationModel: self navigationModel.
	self navigationModel selectCoder: aCoderOrCoders
]

{ #category : #'private - event handling' }
GtCoderNavigationModelElement >> replaceFrom: aGtCoderToReplaceEvent [
	aGtCoderToReplaceEvent consumed: true.
	
	self pushCoder: aGtCoderToReplaceEvent coder
]

{ #category : #'private - event handling' }
GtCoderNavigationModelElement >> spawnFrom: aGtCoderToSpawnEvent [
	aGtCoderToSpawnEvent consumed: true.
	
	self phlow spawnTool: (GtReadyCoderTool coder: (aGtCoderToSpawnEvent coder))
]

{ #category : #'private - event handling' }
GtCoderNavigationModelElement >> spawnInSpaceFrom: aGtCoderToSpawnInSpaceEvent [
	aGtCoderToSpawnInSpaceEvent consumed: true.
]

{ #category : #'private - subscriptions' }
GtCoderNavigationModelElement >> subscribeToNavigationModel [
	"Subclasses can subscribe to the navigation model"
]

{ #category : #'private - subscriptions' }
GtCoderNavigationModelElement >> unsubscribeFromNavigationModel [
	self navigationModel = GtCoderNavigationModel null ifTrue: [ ^ self ].
	self navigationModel unsubscribe: self.
]
