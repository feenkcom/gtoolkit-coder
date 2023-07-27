"
I am the entrance point into the coder as a tool. To instantiate me, use one of the following class-side methods:
- {{gtMethod:GtCoderElement class>>#forObject:|label=#selector}},
- {{gtMethod:GtCoderElement class>>#forClass:|label=#selector}},
- {{gtMethod:GtCoderElement class>>#forMethod:|label=#selector}},
- {{gtMethod:GtCoderElement class>>#forPackage:|label=#selector}},
- {{gtMethod:GtCoderElement class>>#new|label=#selector}}.
1. # Example

{{gtExample:GtCoderElementExamples>>#coderElementWithObject|previewExpanded|codeExpanded=false|previewHeight=700}}


"
Class {
	#name : #GtCoderElement,
	#superclass : #GtAbstractCoderElement,
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
GtCoderElement >> contentElement [
	<return: #GtCoderContentElement>
	^ contentElement
]

{ #category : #'private - accessing' }
GtCoderElement >> contentElement: anElement [
	<return: #GtCoderContentElement>
	contentElement := anElement
]

{ #category : #initialization }
GtCoderElement >> disablePlayPage [
	contentElement disablePlayPage
]

{ #category : #initialization }
GtCoderElement >> initialize [
	super initialize.
	self initializeTitleNotifier.
	self addInteractiveModelState: GtPhlowToolDetailModel new.
	self initializeContentElement.
	self initializeSidebarElement.
	self initializeListeners.
	
	self layout: BlLinearLayout horizontal.
	
	self addChild: self sidebarElement as: #sidebar.
	self addChild: self contentElement as: #content.
	
	self phlow beView.
]

{ #category : #initialization }
GtCoderElement >> initializeContentElement [
	contentElement := GtCoderPlaygroundElement new.
]

{ #category : #initialization }
GtCoderElement >> initializeSidebarElement [
	sidebarElement := GtPhlowHorizontalSidebarElement new beLeft.
	self addAptitude: (GtPhlowToolDetailAptitude new
		normal: [ :theInstance | sidebarElement hide ];
		detailed: [ :theInstance | sidebarElement show ]).
]

{ #category : #initialization }
GtCoderElement >> initializeTitleNotifier [
	titleNotifier := GtPhlowTitleIconAndLabelNotifier new
		shortLabel: [ self shortTitle ifEmpty: [ 'Coder' asRopedText ] ];
		icon: BrGlamorousVectorIcons emphasizedBrowse.
	self addEventHandler: titleNotifier.
]

{ #category : #'private - hooks' }
GtCoderElement >> onNavigationModelChanged [
	super onNavigationModelChanged.
	self contentElement navigationModel: self navigationModel.
	self updateSidebarContent.
	self updateTabLabel
]

{ #category : #'private - announcement handling' }
GtCoderElement >> onNavigationModelSubjectChange [
	self enqueueTask: (BlTaskAction new action: [
		self updateTabLabel ])
]

{ #category : #opening }
GtCoderElement >> pagerWindowTitle [
	<return: #String>
	^ self shortTitle
]

{ #category : #accessing }
GtCoderElement >> repository [

	self navigationModel hasSelectedClass ifTrue: [ 
		^ self navigationModel selectedClass repository ].
	self navigationModel hasSelectedPackage ifTrue: [ 
		^ self navigationModel selectedPackage repository ].
	^ nil
]

{ #category : #filtering }
GtCoderElement >> selectMethodProtocolNamed: aMethodProtocolName [
	"(GtCoder forClass: GtPhlowProtoView) selectMethodProtocolNamed: #decorating"
	| classProtocols |
	classProtocols := navigationModel selectedClass organization protocols.
	classProtocols
		detect: [ :aProtocol | aProtocol name = aMethodProtocolName ]
		ifFound: [ :aProtocol | self navigationModel selectMethodProtocol: aProtocol source: self ]
		ifNone: [  "ignore" ]
]

{ #category : #'private - accessing' }
GtCoderElement >> shortTitle [
	^ (GtPhlowTitleLabelBuilder 
		longLabel: self subjectTitle)
			build
]

{ #category : #'private - accessing' }
GtCoderElement >> sidebarElement [
	<return: #GtPhlowHorizontalSidebarElement>
	^ sidebarElement
]

{ #category : #'private - accessing' }
GtCoderElement >> subjectTitle [
	<return: #String or: nil>
	self navigationModel selectedClassDo: [ :aClass | ^ aClass name ].
	self navigationModel selectedTagDo: [ :aPackageTag | ^ aPackageTag packageName, '-', aPackageTag name ].
	self navigationModel selectedPackageDo: [ :aPackage | ^ aPackage name ].
	^ nil
]

{ #category : #'private - subscriptions' }
GtCoderElement >> subscribeToNavigationModel [
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
GtCoderElement >> titleNotifier [
	<return: #GtPhlowTitleNotifier>
	^ titleNotifier
]

{ #category : #'private - updating' }
GtCoderElement >> updateSidebarContent [
	self sidebarElement
		contentStencil: (GtCoderNavigationTabsStencil new 
			navigationModel: self navigationModel)
]

{ #category : #'private - updating' }
GtCoderElement >> updateTabLabel [
	self titleNotifier notifyIfFocused
]
