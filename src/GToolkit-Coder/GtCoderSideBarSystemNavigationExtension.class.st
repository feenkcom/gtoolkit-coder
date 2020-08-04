Class {
	#name : #GtCoderSideBarSystemNavigationExtension,
	#superclass : #GtPagerPageEmbellisherExtension,
	#instVars : [
		'coder',
		'navigationModel',
		'sideBar',
		'navigationElement',
		'widthStrategy'
	],
	#category : #'GToolkit-Coder-Coder in Pager'
}

{ #category : #'sidebar width' }
GtCoderSideBarSystemNavigationExtension >> adjustSideBarWidth [
	widthStrategy adjustWidthFor: self sideBar.
]

{ #category : #'sidebar width' }
GtCoderSideBarSystemNavigationExtension >> beExact: aNumber [
	widthStrategy := BrResizerElementLength exact: aNumber
]

{ #category : #'sidebar width' }
GtCoderSideBarSystemNavigationExtension >> beWeighted: aNumber [
	widthStrategy := BrResizerElementLength weight: aNumber
]

{ #category : #'private - accessing' }
GtCoderSideBarSystemNavigationExtension >> coder [
	<return: #GtCoder>
	^ coder
]

{ #category : #'private - accessing' }
GtCoderSideBarSystemNavigationExtension >> coder: aGtCoder [
	self
		assert: [ coder isNil ] 
		description: [ 'You can add sidebar navigation extension only once to a coder' ].
	coder := aGtCoder.
]

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> coder: aGtCoder sideBar: anElement navigationModel: aNavigationModel [
	self coder: aGtCoder.
	self sideBar: anElement.
	self navigationModel: aNavigationModel.
	self subscribeToCoder.
	self subscribeToResizer.
	self adjustSideBarWidth.
	self onNavigationModelChanged.
	self sideBar addChild: navigationElement.
]

{ #category : #defaults }
GtCoderSideBarSystemNavigationExtension >> defaultHiddenSideBarWidth [
	^ 3
]

{ #category : #defaults }
GtCoderSideBarSystemNavigationExtension >> defaultWeight [
	^ 0.5
]

{ #category : #'widget configuration' }
GtCoderSideBarSystemNavigationExtension >> fillToolWidgetIn: aCreationContext [
	"initialize a tool widget"
	"self sideBar addChild: navigationElement."
]

{ #category : #'sidebar width' }
GtCoderSideBarSystemNavigationExtension >> hideSideBar [
	self sideBar width: self defaultHiddenSideBarWidth
]

{ #category : #initialization }
GtCoderSideBarSystemNavigationExtension >> initialize [
	super initialize.
	self initializeWidthStrategy.
]

{ #category : #initialization }
GtCoderSideBarSystemNavigationExtension >> initializeNavigationElement [
	navigationElement := (GtCoderNavigationTabsStencil new 
		navigationModel: navigationModel;
		asElement).
	navigationElement background: BrGlamorousColors neutralBackgroundColor
]

{ #category : #initialization }
GtCoderSideBarSystemNavigationExtension >> initializeWidthStrategy [
	widthStrategy := BrResizerElementLength weight: self defaultWeight.
]

{ #category : #'sidebar width' }
GtCoderSideBarSystemNavigationExtension >> isSideBarHidden [
	<return: #Boolean>
	^ self sideBar width <= self defaultHiddenSideBarWidth
]

{ #category : #'private - accessing' }
GtCoderSideBarSystemNavigationExtension >> navigationModel [
	^ navigationModel
]

{ #category : #'private - accessing' }
GtCoderSideBarSystemNavigationExtension >> navigationModel: anObject [
	navigationModel := anObject.
]

{ #category : #hooks }
GtCoderSideBarSystemNavigationExtension >> onMaximizedInPager: aPager [
	self sideBar visibility: BlVisibility visible.
]

{ #category : #hooks }
GtCoderSideBarSystemNavigationExtension >> onMinimizedInPager: aPager [
	self sideBar visibility: BlVisibility gone.
]

{ #category : #hooks }
GtCoderSideBarSystemNavigationExtension >> onNavigationModelChanged [
	self initializeNavigationElement.
]

{ #category : #hooks }
GtCoderSideBarSystemNavigationExtension >> onResizerDoubleClick: anEvent [
	anEvent consumed: true.
	self isSideBarHidden
		ifTrue: [ self adjustSideBarWidth ]
		ifFalse: [ self hideSideBar ]
]

{ #category : #hooks }
GtCoderSideBarSystemNavigationExtension >> onResizerResized: anEvent [
	self beExact: anEvent extent x
]

{ #category : #'private - accessing' }
GtCoderSideBarSystemNavigationExtension >> sideBar [
	<return: #BlElement>
	^ sideBar
]

{ #category : #'private - accessing' }
GtCoderSideBarSystemNavigationExtension >> sideBar: anElement [
	sideBar := anElement.
]

{ #category : #subscriptions }
GtCoderSideBarSystemNavigationExtension >> subscribeToCoder [
	self coder addLook: (GtPhlowToolVolumeLook new
		normal: [ self onMinimizedInPager: nil ];
		detailed: [ self onMaximizedInPager: nil ]).
]

{ #category : #subscriptions }
GtCoderSideBarSystemNavigationExtension >> subscribeToResizer [
	self coder
		leftSideBarResizerDo: [ :aResizer | 
			aResizer
				when: BlResizerResizedEvent
					do: [ :anEvent | self onResizerResized: anEvent ];
				when: BlDoubleClickEvent
					do:
						[ :anEvent | self onResizerDoubleClick: anEvent ] ]
]

{ #category : #'private - accessing' }
GtCoderSideBarSystemNavigationExtension >> weight [
	^ 0.5
]
