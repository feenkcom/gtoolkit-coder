"
I am the entrance point into the coder as a tool. To instantiate me, use one of the following class-side methods:
- ${method:GtCoder class>>#forObject:|label=#selector}$,
- ${method:GtCoder class>>#forClass:|label=#selector}$,
- ${method:GtCoder class>>#forMethod:|label=#selector}$,
- ${method:GtCoder class>>#forPackage:|label=#selector}$,
- ${method:GtCoder class>>#new|label=#selector}$.
!! Example
${example:GtCoderElementExamples>>#coderElementWithObject|previewExpanded|codeExpanded=false|previewHeight=700}$

"
Class {
	#name : #GtCoder,
	#superclass : #GtCoderNavigationModelElement,
	#instVars : [
		'sidebarElement',
		'contentElement',
		'toolbarElement'
	],
	#category : #'GToolkit-Coder-! Core'
}

{ #category : #'instance creation' }
GtCoder class >> forClass: aClass [
	^ self forCoder: (GtClassCoder forClass: aClass)
]

{ #category : #'instance creation' }
GtCoder class >> forCoder: aCoder [
	^ self basicNew initialize
		navigationModel: GtCoderNavigationModel default;
		pushCoder: aCoder
]

{ #category : #'instance creation' }
GtCoder class >> forMethod: aCompiledMethod [
    | classCoder coder |
    classCoder := GtClassCoder forClass: aCompiledMethod methodClass instanceSide.
    coder := self forCoder: classCoder.
    classCoder withSelectedMethod: aCompiledMethod.
    ^ coder
]

{ #category : #'instance creation' }
GtCoder class >> forObject: anObject [
	^ self forCoder: (GtClassCoder forObject: anObject)
]

{ #category : #'instance creation' }
GtCoder class >> forPackage: anRPackage [
	^ self forCoder: (GtPackageCoder forPackage: anRPackage)
]

{ #category : #'instance creation' }
GtCoder class >> new [
	^ self forCoder: GtPackagesCoder new
]

{ #category : #'private - accessing' }
GtCoder >> contentElement [
	<return: #GtCoderContentElement>
	^ contentElement
]

{ #category : #initialization }
GtCoder >> initialize [
	super initialize.
	self addInteractiveModelState: GtPhlowToolVolumeModel new.
	self initializeContentElement.
	self initializeSidebarElement.
	self initializeToolbarElement.
	
	self layout: BlLinearLayout horizontal.
	
	self addChild: self sidebarElement as: #sidebar.
	self addChild: self contentElement as: #content.
	self addChild: self toolbarElement as: #toolbar.
	
	self addLook: (BrLayoutResizerLook inherit).
]

{ #category : #initialization }
GtCoder >> initializeContentElement [
	contentElement := GtCoderPlaygroundElement new.
]

{ #category : #initialization }
GtCoder >> initializeSidebarElement [
	sidebarElement := GtPhlowHorizontalSidebarElement new beLeft.
	self addLook: (GtPhlowToolVolumeLook new
		normal: [ :theInstance | sidebarElement hide ];
		detailed: [ :theInstance | sidebarElement show ]).
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
]

{ #category : #'private - accessing' }
GtCoder >> sidebarElement [
	<return: #GtPhlowHorizontalSidebarElement>
	^ sidebarElement
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
