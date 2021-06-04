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
		'toolbarElement',
		'titleNotifier'
	],
	#category : #'GToolkit-Coder-UI-! Core'
}

{ #category : #'private - accessing' }
GtCoder >> contentElement [
	<return: #GtCoderContentElement>
	^ contentElement
]

{ #category : #initialization }
GtCoder >> initialize [
	super initialize.
	self initializeTitleNotifier.
	self addInteractiveModelState: GtPhlowToolDetailModel new.
	self initializeContentElement.
	self initializeSidebarElement.
	self initializeToolbarElement.
	self initializeListeners.
	
	self layout: BlLinearLayout horizontal.
	
	self addChild: self sidebarElement as: #sidebar.
	self addChild: self contentElement as: #content.
	self addChild: self toolbarElement as: #toolbar.
	
	self addAptitude: (BrLayoutResizerAptitude inherit).
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

{ #category : #initialization }
GtCoder >> initializeToolbarElement [
	toolbarElement := GtCoderToolbarElement new
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignTop ].
]

{ #category : #'private - hooks' }
GtCoder >> onNavigationModelChanged [
	super onNavigationModelChanged.
	self contentElement navigationModel: self navigationModel.
	self toolbarElement navigationModel: self navigationModel.
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

{ #category : #'private - accessing' }
GtCoder >> toolbarElement [
	<return: #GtCoderToolbarElement>
	^ toolbarElement
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
