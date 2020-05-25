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
	navigationModel := aGtCoderNavigationPackagesTagsClassesModel.
	self onNavigationModelChanged.
]

{ #category : #'event handling' }
GtCoderNavigationElement >> onNavigationModelChanged [
	"subclasses may perform actions on navigation model changes"
]

{ #category : #subscriptions }
GtCoderNavigationElement >> suppressListChangeEventsDuring: aBlock [
	supressListChanges := true.
	aBlock ensure: [ supressListChanges := false ].
]

{ #category : #subscriptions }
GtCoderNavigationElement >> suppressNavigationChangeEventsDuring: aBlock [
	supressNavigationChanges := true.
	aBlock ensure: [ supressNavigationChanges := false ].
]
