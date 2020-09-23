"
I display a ${class:GtClassCoder}$, ${class:GtPackageTagCoder}$, ${class:GtPackageCoder}$, and ${class:GtCodersModel}$ coders.
!! Example
${example:GtCoderElementExamples>>#contentElementWithClass|previewExpanded|codeExpanded=false|previewHeight=700}$

"
Class {
	#name : #GtCoderContentElement,
	#superclass : #GtCoderNavigationModelElement,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #factory }
GtCoderContentElement class >> default [
	^ self new
		navigationModel: GtCoderNavigationModel default
]

{ #category : #initialization }
GtCoderContentElement >> initialize [
	super initialize.
	self layout: BlFrameLayout new.
	
	self addLook: (BrLayoutResizerLook inherit).
]

{ #category : #initialization }
GtCoderContentElement >> initializeListeners [
	self
		when: GtCoderToReplace
		do: [ :anEvent | self replaceFrom: anEvent ].

	self
		when: GtCoderToSpawn
		do: [ :anEvent | self spawnFrom: anEvent ].
]

{ #category : #'hooks - children' }
GtCoderContentElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	self navigationModel subscribeToSystem.
]

{ #category : #'hooks - children' }
GtCoderContentElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	self navigationModel unsubscribeFromSystem.
]

{ #category : #'private - event handling' }
GtCoderContentElement >> replaceFrom: aGtCoderToReplaceEvent [
	aGtCoderToReplaceEvent consumed: true.
	
	self pushCoder: aGtCoderToReplaceEvent coder
]

{ #category : #'private - event handling' }
GtCoderContentElement >> spawnFrom: aGtCoderToSpawnEvent [
	aGtCoderToSpawnEvent consumed: true.
	
	self phlow spawnTool: (GtReadyCoderTool coder: (aGtCoderToSpawnEvent coder))
]

{ #category : #'private - subscriptions' }
GtCoderContentElement >> subscribeToNavigationModel [
	super subscribeToNavigationModel.
	self navigationModel weak
		when: GtCoderNavigationSelectionAnnouncement send: #updateCoder: to: self.
]

{ #category : #'private - event handling' }
GtCoderContentElement >> updateCoder: anAnnouncement [
	self removeChildren.
	self addChild: anAnnouncement coder asElement.
]
