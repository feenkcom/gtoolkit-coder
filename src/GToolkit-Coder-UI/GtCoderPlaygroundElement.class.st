"
I display {{gtClass:GtCoderContentElement}} and an embedded playground.
1. # Example

{{gtExample:GtCoderElementExamples>>#playgroundElementWithClass|previewExpanded|codeExpanded=false|previewHeight=700}}


"
Class {
	#name : 'GtCoderPlaygroundElement',
	#superclass : 'GtCoderNavigationModelElement',
	#instVars : [
		'contentElement',
		'playgroundElement'
	],
	#category : 'GToolkit-Coder-UI-Basic'
}

{ #category : 'private - accessing' }
GtCoderPlaygroundElement >> contentElement [
	<return: #GtCoderContentElement>
	^ contentElement
]

{ #category : 'initialization' }
GtCoderPlaygroundElement >> initialize [
	super initialize.
	
	self initializeContentElement.
	self initializePlayPageElement.
	
	self layout: BlLinearLayout vertical.
	
	self addChild: self contentElement as: #content.
	self addChild: self playPageElement as: #playPage
]

{ #category : 'initialization' }
GtCoderPlaygroundElement >> initializeContentElement [
	contentElement := GtCoderContentElement new.
]

{ #category : 'initialization' }
GtCoderPlaygroundElement >> initializePlayPageElement [
	playgroundElement := (GtInspector environment 
		at: GtInspector embeddedPlaygroundName 
		ifAbsent: [ GtInspectorPlaygroundElement ]) new.
	
	playgroundElement collapse.
	playgroundElement objectHolder: self objectHolder
]

{ #category : 'private - accessing' }
GtCoderPlaygroundElement >> objectHolder [
	^ GtInspectorObject new object: self receiver
]

{ #category : 'private - hooks' }
GtCoderPlaygroundElement >> onClassSelected: anEvent [
	self updatePlayground
]

{ #category : 'private - hooks' }
GtCoderPlaygroundElement >> onNavigationModelChanged [
	super onNavigationModelChanged.
	self contentElement navigationModel: self navigationModel.
	self updatePlayground.
]

{ #category : 'private - hooks' }
GtCoderPlaygroundElement >> onPackageSelected: anEvent [
	self updatePlayground
]

{ #category : 'private - hooks' }
GtCoderPlaygroundElement >> onPackageTagSelected: anEvent [
	self updatePlayground
]

{ #category : 'private - hooks' }
GtCoderPlaygroundElement >> onPackagesSelected: anEvent [
	self updatePlayground
]

{ #category : 'private - accessing' }
GtCoderPlaygroundElement >> playPageElement [
	<return: #GtPhlowVerticalSidebarElement>
	^ playgroundElement
]

{ #category : 'private - accessing' }
GtCoderPlaygroundElement >> receiver [
	self navigationModel selectedClassDo: [ :aClass | ^ aClass ].
	self navigationModel selectedTagDo: [ :aPackageTag | ^ aPackageTag ].
	self navigationModel selectedPackageDo: [ :aPackage | ^ aPackage ].
	^ Smalltalk
]

{ #category : 'private - subscriptions' }
GtCoderPlaygroundElement >> subscribeToNavigationModel [
	super subscribeToNavigationModel.
	self navigationModel weak
		when: GtCoderNavigationPackagesSelected send: #onPackagesSelected: to: self;
		when: GtCoderNavigationPackageSelected send: #onPackageSelected: to: self;
		when: GtCoderNavigationPackageTagSelected send: #onPackageTagSelected: to: self;
		when: GtCoderNavigationClassSelected send: #onClassSelected: to: self.
]

{ #category : 'private - updating' }
GtCoderPlaygroundElement >> updatePlayground [
	self playPageElement objectHolder: self objectHolder
]
