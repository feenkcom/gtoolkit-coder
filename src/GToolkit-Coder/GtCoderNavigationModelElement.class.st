"
I am an abstract class.
I provide basic ${method:GtCoderNavigationModelElement>>#navigationModel:|label=navigation}$ accessors, model ${method:GtCoderNavigationModelElement>>#subscribeToNavigationModel|label=subscriptons}$, and model ${method:GtCoderNavigationModelElement>>#onNavigationModelChanged|label=instance changes}$.
See my ${class:GtCoderNavigationModelElement|expanded|show=#gtSubclassesFor:}$ for concrete implementations:
"
Class {
	#name : #GtCoderNavigationModelElement,
	#superclass : #GtCoderElement,
	#instVars : [
		'navigationModel'
	],
	#category : #'GToolkit-Coder-UI'
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

{ #category : #'private - subscriptions' }
GtCoderNavigationModelElement >> subscribeToNavigationModel [
	"Subclasses can subscribe to the navigation model"
]

{ #category : #'private - subscriptions' }
GtCoderNavigationModelElement >> unsubscribeFromNavigationModel [
	self navigationModel = GtCoderNavigationModel null ifTrue: [ ^ self ].
	self navigationModel unsubscribe: self.
]
