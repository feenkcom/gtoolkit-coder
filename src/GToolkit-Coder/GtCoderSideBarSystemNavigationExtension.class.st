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

{ #category : #'widget configuration' }
GtCoderSideBarSystemNavigationExtension >> adjustSideBarWidth [
	widthStrategy adjustWidthFor: self sideBar.
]

{ #category : #converting }
GtCoderSideBarSystemNavigationExtension >> beExact: aNumber [
	widthStrategy := BrResizerElementLength exact: aNumber
]

{ #category : #converting }
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
GtCoderSideBarSystemNavigationExtension >> defaultWeight [
	^ 0.5
]

{ #category : #'widget configuration' }
GtCoderSideBarSystemNavigationExtension >> fillToolWidgetIn: aCreationContext [
	"initialize a tool widget"
	self sideBar addChild: navigationElement.
]

{ #category : #initialization }
GtCoderSideBarSystemNavigationExtension >> initialize [
	super initialize.
	self initializeWidthStrategy.
]

{ #category : #initialization }
GtCoderSideBarSystemNavigationExtension >> initializeNavigationElement [
	navigationElement := (GtCoderSideBarNavigationPackagesTagsClassesElement new 
		navigationModel: navigationModel).
]

{ #category : #initialization }
GtCoderSideBarSystemNavigationExtension >> initializeWidthStrategy [
	widthStrategy := BrResizerElementLength weight: self defaultWeight.
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
	self adjustSideBarWidth.
]

{ #category : #hooks }
GtCoderSideBarSystemNavigationExtension >> onMinimizedInPager: aPager [
	self sideBar constraintsDo: [ :c | c horizontal exact: 0 ].
]

{ #category : #hooks }
GtCoderSideBarSystemNavigationExtension >> onNavigationModelChanged [
	self initializeNavigationElement.
]

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> sideBar [
	<return: #BlElement>
	^ sideBar
]

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> sideBar: anElement [
	sideBar := anElement
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
	self coder leftSideBarResizerDo: [ :aResizer | 
		aResizer
			when: BlResizerResizedEvent
				do: [ :anEvent |
					self beExact: anEvent extent x ];
			when: BlDoubleClickEvent
				do: [ :anEvent | 
					anEvent consumed: true.
					self beWeighted: self defaultWeight.
					self adjustSideBarWidth ] ]
]

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> weight [
	^ 0.5
]
