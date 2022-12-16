"
I am the entrance point into the coder as a tool. To instantiate me, use one of the following class-side methods:
- {{gtMethod:GtCoder class>>#forObject:|label=#selector}},
- {{gtMethod:GtCoder class>>#forClass:|label=#selector}},
- {{gtMethod:GtCoder class>>#forMethod:|label=#selector}},
- {{gtMethod:GtCoder class>>#forPackage:|label=#selector}},
- {{gtMethod:GtCoder class>>#new|label=#selector}}.
1. # Example

{{gtExample:GtCoderElementExamples>>#coderElementWithObject|previewExpanded|codeExpanded=false|previewHeight=700}}


"
Class {
	#name : #GtCoder,
	#superclass : #GtCoderNavigationModelElement,
	#traits : 'TGtPagerPageInstantiator + TGtPhlowToolDetailAdjustable',
	#classTraits : 'TGtPagerPageInstantiator classTrait + TGtPhlowToolDetailAdjustable classTrait',
	#instVars : [
		'sidebarElement',
		'contentElement',
		'titleNotifier'
	],
	#category : #'GToolkit-Coder-UI-! Core'
}

{ #category : #'private - accessing' }
GtCoder >> contentElement [
	<return: #GtCoderContentElement>
	^ contentElement
]

{ #category : #'private - accessing' }
GtCoder >> contentElement: anElement [
	<return: #GtCoderContentElement>
	contentElement := anElement
]

{ #category : #initialization }
GtCoder >> disablePlayPage [
	contentElement disablePlayPage
]

{ #category : #initialization }
GtCoder >> initialize [
	super initialize.
	self initializeTitleNotifier.
	self addInteractiveModelState: GtPhlowToolDetailModel new.
	self initializeContentElement.
	self initializeSidebarElement.
	self initializeListeners.
	
	self layout: BlLinearLayout horizontal.
	
	self addChild: self sidebarElement as: #sidebar.
	self addChild: self contentElement as: #content.
	
	self addAptitude: (BrLayoutResizerAptitude inherit).
	
	self phlow beView.
]

{ #category : #initialization }
GtCoder >> initializeContentElement [
	contentElement := GtCoderPlaygroundElement new.
]

{ #category : #initialization }
GtCoder >> initializeSidebarElement [
	sidebarElement := GtPhlowHorizontalSidebarElement new beLeft.
	self addAptitude: (GtPhlowToolDetailAptitude new
		normal: [ :theInstance | sidebarElement hide ];
		detailed: [ :theInstance | sidebarElement show ]).
]

{ #category : #initialization }
GtCoder >> initializeTitleNotifier [
	titleNotifier := GtPhlowTitleIconAndLabelNotifier new
		shortLabel: [ self shortTitle ifEmpty: [ 'Coder' asRopedText ] ];
		icon: BrGlamorousVectorIcons emphasizedBrowse.
	self addEventHandler: titleNotifier.
]

{ #category : #'private - hooks' }
GtCoder >> onNavigationModelChanged [
	super onNavigationModelChanged.
	self contentElement navigationModel: self navigationModel.
	self updateSidebarContent.
	self updateTabLabel
]

{ #category : #'private - announcement handling' }
GtCoder >> onNavigationModelSubjectChange [
	self enqueueTask: (BlTaskAction new action: [
		self updateTabLabel ])
]

{ #category : #opening }
GtCoder >> pagerWindowTitle [
	<return: #String>
	^ self shortTitle
]

{ #category : #accessing }
GtCoder >> repository [

	self navigationModel hasSelectedClass ifTrue: [ 
		^ self navigationModel selectedClass repository ].
	self navigationModel hasSelectedPackage ifTrue: [ 
		^ self navigationModel selectedPackage repository ].
	^ nil
]

{ #category : #'private - accessing' }
GtCoder >> shortTitle [
	^ (GtPhlowTitleLabelBuilder 
		longLabel: self subjectTitle)
			build
]

{ #category : #'private - accessing' }
GtCoder >> sidebarElement [
	<return: #GtPhlowHorizontalSidebarElement>
	^ sidebarElement
]

{ #category : #'private - accessing' }
GtCoder >> subjectTitle [
	<return: #String or: nil>
	self navigationModel selectedClassDo: [ :aClass | ^ aClass name ].
	self navigationModel selectedTagDo: [ :aPackageTag | ^ aPackageTag packageName, '-', aPackageTag name ].
	self navigationModel selectedPackageDo: [ :aPackage | ^ aPackage name ].
	^ nil
]

{ #category : #'private - subscriptions' }
GtCoder >> subscribeToNavigationModel [
	super subscribeToNavigationModel.
	self navigationModel weak 
		when: GtCoderNavigationPackagesSelected,
			GtCoderNavigationPackageSelected,
			GtCoderNavigationPackageRenamed,
			GtCoderNavigationPackageTagSelected,
			GtCoderNavigationClassSelected,
			GtCoderNavigationClassRenamed,
			GtCoderNavigationClassModified
		send: #onNavigationModelSubjectChange to: self
]

{ #category : #'private - accessing' }
GtCoder >> titleNotifier [
	<return: #GtPhlowTitleNotifier>
	^ titleNotifier
]

{ #category : #'private - updating' }
GtCoder >> updateSidebarContent [
	self sidebarElement
		contentStencil: (GtCoderNavigationTabsStencil new 
			navigationModel: self navigationModel)
]

{ #category : #'private - updating' }
GtCoder >> updateTabLabel [
	self titleNotifier notifyIfFocused
]
