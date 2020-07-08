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

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> coder [
	<return: #GtCoder>
	^ coder
]

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> coder: aGtCoder [
	coder := aGtCoder.
	self subscribeToCoder.
	self subscribeToResizer.
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
	self sideBar addChild: navigationElement.
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

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> navigationModel [
	^ navigationModel
]

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> navigationModel: anObject [
	navigationModel := anObject.
	self onNavigationModelChanged.
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

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> sideBar [
	<return: #BlElement>
	^ sideBar
]

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> sideBar: anElement [
	sideBar := anElement.
	self adjustSideBarWidth.
]

{ #category : #subscriptions }
GtCoderSideBarSystemNavigationExtension >> subscribeToCoder [
	self coder when: GtPagerPageMaximizedEvent do: [ :anEvent | 
		self onMaximizedInPager: anEvent pager ].
	self coder when: GtPagerPageMinimizedEvent do: [ :anEvent | 
		self onMinimizedInPager: anEvent pager ].
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

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> weight [
	^ 0.5
]
