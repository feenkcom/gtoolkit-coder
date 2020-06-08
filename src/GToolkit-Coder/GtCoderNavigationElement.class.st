Class {
	#name : #GtCoderNavigationElement,
	#superclass : #BlElement,
	#instVars : [
		'navigationModel',
		'supressNavigationChanges',
		'supressListChanges'
	],
	#category : #'GToolkit-Coder-Navigation - UI'
}

{ #category : #asserting }
GtCoderNavigationElement >> assertNavigationModel: aGtCoderNavigationPackagesTagsClassesModel [
	self 
		assert: [ aGtCoderNavigationPackagesTagsClassesModel isNotNil ] 
		description: [ 'Navigation model must be non-nil' ].
]

{ #category : #testing }
GtCoderNavigationElement >> hasNavigationModel [
	^ self navigationModel isNotNil
]

{ #category : #initialization }
GtCoderNavigationElement >> initialize [
	super initialize.
	supressListChanges := false.
	supressNavigationChanges := false.
	self initializeLayout.
	self initializeContent.
	self initializeElement.
]

{ #category : #initialization }
GtCoderNavigationElement >> initializeContent [
	"subclasses may initialize the content, e.g., list elements"
]

{ #category : #initialization }
GtCoderNavigationElement >> initializeElement [
	"subclasses may initialize element"
]

{ #category : #initialization }
GtCoderNavigationElement >> initializeLayout [
	"subclasses may define its layout"
]

{ #category : #accessing }
GtCoderNavigationElement >> navigationModel [
	<return: #GtCoderNavigationPackagesTagsClassesModel>

	^ navigationModel
]

{ #category : #accessing }
GtCoderNavigationElement >> navigationModel: aGtCoderNavigationPackagesTagsClassesModel [
	self assertNavigationModel: aGtCoderNavigationPackagesTagsClassesModel.
	self unsubscribeFromNavigationModel.
	navigationModel := aGtCoderNavigationPackagesTagsClassesModel.
	self onNavigationModelChanged.
]

{ #category : #'hooks - children' }
GtCoderNavigationElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	self updateContent.
	self subscribeToNavigationModel.
	self subscribeToContent.
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onNavigationModelChanged [
	"subclasses may perform actions on navigation model changes"
	self isAttachedToSceneGraph ifFalse: [ ^ self ].
	self subscribeToNavigationModel.
	self updateContent.
]

{ #category : #'hooks - children' }
GtCoderNavigationElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	self unsuscribeFromContent.
	self unsubscribeFromNavigationModel.
]

{ #category : #subscriptions }
GtCoderNavigationElement >> subscribeToContent [
]

{ #category : #subscriptions }
GtCoderNavigationElement >> subscribeToNavigationModel [
]

{ #category : #subscriptions }
GtCoderNavigationElement >> suppressListChangeEventsDuring: aBlock [
	| anOldValue |
	anOldValue := supressListChanges.
	supressListChanges := true.
	aBlock ensure: [ supressListChanges := anOldValue ].
]

{ #category : #subscriptions }
GtCoderNavigationElement >> suppressNavigationChangeEventsDuring: aBlock [
	| anOldValue |
	anOldValue := supressNavigationChanges.
	supressNavigationChanges := true.
	aBlock ensure: [ supressNavigationChanges := anOldValue ].
]

{ #category : #subscriptions }
GtCoderNavigationElement >> unsubscribeFromNavigationModel [
	navigationModel ifNotNil: [ :aModel | aModel unsubscribe: self ].
]

{ #category : #subscriptions }
GtCoderNavigationElement >> unsuscribeFromContent [
]

{ #category : #updating }
GtCoderNavigationElement >> updateContent [
]
