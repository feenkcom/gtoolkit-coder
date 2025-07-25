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

{ #category : #'instance creation' }
GtCoderElement class >> defaultSidebarWidth [
	^ 1.0
]

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

{ #category : #'instance creation' }
GtCoderElement >> createPlaygroundElement [
	^ GtCoderPlaygroundElement new
]

{ #category : #'instance creation' }
GtCoderElement >> createSidebarElement [
	^ GtPhlowHorizontalSidebarElement new
		beLeft;
		resizerStrategy: (BrResizerElementLength weight: self class defaultSidebarWidth);
		contentStencil: (GtCoderNavigationTabsStencil new navigationModel: self navigationModel);
		addAptitude: (GtPhlowToolDetailAptitude new
				left: [ :aStyle | 
					aStyle
						do: [ :aWidget | 
							aWidget userData
								at: #leftSidebarResizerStrategy
								ifPresent: [ :aResizerStrategy | aWidget resizerStrategy: aResizerStrategy ]
								ifAbsentPut: [ aWidget
										resizerStrategy: (BrResizerElementLength weight: self class defaultSidebarWidth) ].
							aWidget beLeft.
							aWidget userData
								at: #leftSidebarIsCollapsed
								ifPresent: [ :aBoolean | aBoolean ifTrue: [ aWidget collapse ] ]
								ifAbsent: [  ] ]
						after: [ :aWidget | 
							aWidget userData at: #leftSidebarResizerStrategy put: aWidget resizerStrategy.
							aWidget userData at: #leftSidebarIsCollapsed put: aWidget isCollapsed ] ];
				top: [ :aStyle | 
					aStyle
						do: [ :aWidget | 
							aWidget userData
								at: #topSidebarResizerStrategy
								ifPresent: [ :aResizerStrategy | aWidget resizerStrategy: aResizerStrategy ]
								ifAbsentPut: [ aWidget
										resizerStrategy: (BrResizerElementLength weight: 0.5) ].
							aWidget beTop.
							aWidget userData
								at: #topSidebarIsCollapsed
								ifPresent: [ :aBoolean | aBoolean ifTrue: [ aWidget collapse ] ]
								ifAbsent: [  ] ]
						after: [ :aWidget | 
							aWidget userData at: #topSidebarResizerStrategy put: aWidget resizerStrategy.
							aWidget userData at: #topSidebarIsCollapsed put: aWidget isCollapsed ] ])
]

{ #category : #'instance creation' }
GtCoderElement >> createTitleNotifier [
	^ GtPhlowTitleIconAndLabelNotifier new
		shortLabel: [ self shortTitle ifEmpty: [ 'Coder' asRopedText ] ];
		icon: BrGlamorousVectorIcons emphasizedBrowse
]

{ #category : #accessing }
GtCoderElement >> disablePlayPage [
	contentElement disablePlayPage
]

{ #category : #'private - updating' }
GtCoderElement >> hideSidebar [
	sidebarElement ifNil: [ ^ self ].
	sidebarElement
		hide;
		removeFromParent
]

{ #category : #initialization }
GtCoderElement >> initialize [
	super initialize.

	contentElement := self createPlaygroundElement.

	titleNotifier := self createTitleNotifier.

	self
		layout: BlLinearLayout horizontal;
		addEventHandler: titleNotifier;
		addAptitude: (GtPhlowToolDetailAptitude new
				normal: [ :aStyle | aStyle do: [ self hideSidebar ] ];
				detailed: [ :aStyle | aStyle do: [ self showSidebar ] ];
				left: [ :aStyle | aStyle do: [ self layout: BlLinearLayout horizontal ] ];
				top: [ :aStyle | aStyle do: [ self layout: BlLinearLayout vertical ] ]).

	self addChild: contentElement as: #content.

	self phlow beViewContent.
	self phlow
		accessTool: (GtPhlowToolClassType forClass: GtCoderElement)
		viewModel: #navigationModel
		object: #navigationModel.

	GtCoderSettings defaultDetailState
		ifNotNil: [ :aState | self states addState: aState ].
	GtCoderSettings defaultDetailPositionState
		ifNotNil: [ :aState | self states addState: aState ]
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
		ifFound: [ :aProtocol | self navigationModel selectProtocol: aProtocol source: self ]
		ifNone: [  "ignore" ]
]

{ #category : #'private - accessing' }
GtCoderElement >> shortTitle [
	^ (GtPhlowTitleLabelBuilder 
		longLabel: self subjectTitle)
			build
]

{ #category : #'private - updating' }
GtCoderElement >> showSidebar [
	sidebarElement ifNil: [ sidebarElement := self createSidebarElement ].
	sidebarElement show.

	(sidebarElement hasParent: self)
		ifTrue: [ ^ self ].
		
	self addChildFirst: sidebarElement
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
			GtCoderNavigationPackageTagRenamed,
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
	sidebarElement ifNil: [ ^ self ].
	sidebarElement contentStencil: (GtCoderNavigationTabsStencil new navigationModel: self navigationModel)
]

{ #category : #'private - updating' }
GtCoderElement >> updateTabLabel [
	self titleNotifier notifyIfFocused
]
