"
I display a {{gtClass:GtBehaviorCoder}}, {{gtClass:GtPackageTagCoder}}, {{gtClass:GtPackageCoder}}, and {{gtClass:GtCodersModel}} coders.
1. # Example

{{gtExample:GtCoderElementExamples>>#contentElementWithClass|previewExpanded|codeExpanded=false|previewHeight=700}}


"
Class {
	#name : #GtCoderContentElement,
	#superclass : #GtCoderNavigationModelElement,
	#category : #'GToolkit-Coder-UI-Basic'
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
	
	self addAptitude: (BrLayoutResizerAptitude inherit).
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
