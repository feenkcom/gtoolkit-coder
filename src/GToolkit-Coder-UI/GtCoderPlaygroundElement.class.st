"
I display ${class:GtCoderContentElement}$ and ${class:GtPageElement}$.
!! Example
${example:GtCoderElementExamples>>#playgroundElementWithClass|previewExpanded|codeExpanded=false|previewHeight=700}$

"
Class {
	#name : #GtCoderPlaygroundElement,
	#superclass : #GtCoderNavigationModelElement,
	#instVars : [
		'contentElement',
		'playPageElement',
		'playPage'
	],
	#category : #'GToolkit-Coder-UI-Basic'
}

{ #category : #'private - accessing' }
GtCoderPlaygroundElement >> contentElement [
	<return: #GtCoderContentElement>
	^ contentElement
]

{ #category : #defaults }
GtCoderPlaygroundElement >> defaultPlayPage [
	^ GtPlayPage newDefault.
]

{ #category : #initialization }
GtCoderPlaygroundElement >> initialize [
	super initialize.
	playPage := self defaultPlayPage.
	self initializeContentElement.
	self initializePlayPageElement.
	
	self layout: BlLinearLayout vertical.
	
	self addChild: self contentElement as: #content.
	self addChild: self playPageElement as: #playPage.
	
	self addLook: (BrLayoutResizerLook inherit).
]

{ #category : #initialization }
GtCoderPlaygroundElement >> initializeContentElement [
	contentElement := GtCoderContentElement new.
]

{ #category : #initialization }
GtCoderPlaygroundElement >> initializePlayPageElement [
	| aStencil |
	aStencil := GtPlayPageStencil new
		playPage: self playPage;
		receiver: self receiver.
	playPageElement := GtPhlowVerticalSidebarElement new
		beBottom;
		show;
		collapse;
		background: BrGlamorousColors neutralBackgroundColor;
		contentStencil: aStencil.
]

{ #category : #'private - hooks' }
GtCoderPlaygroundElement >> onClassSelected: anEvent [
	self playPage receiver: anEvent theClass.
	self playPage xDocLoadSavedContent.

]

{ #category : #'private - hooks' }
GtCoderPlaygroundElement >> onNavigationModelChanged [
	super onNavigationModelChanged.
	self contentElement navigationModel: self navigationModel.
	self updatePlayground.
]

{ #category : #'private - hooks' }
GtCoderPlaygroundElement >> onPackageSelected: anEvent [
	self playPage receiver: anEvent package.
	self playPage xDocLoadSavedContent.
]

{ #category : #'private - hooks' }
GtCoderPlaygroundElement >> onPackageTagSelected: anEvent [
	self playPage receiver: anEvent tag.
	self playPage xDocLoadSavedContent.
]

{ #category : #'private - hooks' }
GtCoderPlaygroundElement >> onPackagesSelected: anEvent [
	self playPage receiver: Smalltalk.
	self playPage xDocLoadSavedContent.
]

{ #category : #'private - accessing' }
GtCoderPlaygroundElement >> playPage [
	<return: #GtPlayPage>
	^ playPage
]

{ #category : #'private - accessing' }
GtCoderPlaygroundElement >> playPageElement [
	<return: #GtPhlowVerticalSidebarElement>
	^ playPageElement
]

{ #category : #'private - accessing' }
GtCoderPlaygroundElement >> receiver [
	self navigationModel selectedClassDo: [ :aClass | ^ aClass ].
	self navigationModel selectedTagDo: [ :aPackageTag | ^ aPackageTag ].
	self navigationModel selectedPackageDo: [ :aPackage | ^ aPackage ].
	^ Smalltalk
]

{ #category : #'private - subscriptions' }
GtCoderPlaygroundElement >> subscribeToNavigationModel [
	super subscribeToNavigationModel.
	self navigationModel weak
		when: GtCoderNavigationPackagesSelected send: #onPackagesSelected: to: self;
		when: GtCoderNavigationPackageSelected send: #onPackageSelected: to: self;
		when: GtCoderNavigationPackageTagSelected send: #onPackageTagSelected: to: self;
		when: GtCoderNavigationClassSelected send: #onClassSelected: to: self.
]

{ #category : #'private - updating' }
GtCoderPlaygroundElement >> updatePlayground [
	self playPage receiver: self receiver.
	self playPage xDocLoadSavedContent.
]
