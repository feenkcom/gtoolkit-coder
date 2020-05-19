Class {
	#name : #GtCoderSideBarSystemNavigationExtension,
	#superclass : #GtPagerPageEmbellisherExtension,
	#instVars : [
		'coder',
		'navigationModel',
		'sideBar',
		'navigationElement'
	],
	#category : #'GToolkit-Coder-Coder in Pager'
}

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> coder [
	<return: #GtCoder>
	^ coder
]

{ #category : #accessing }
GtCoderSideBarSystemNavigationExtension >> coder: aGtCoder [
	coder := aGtCoder.
	self subscribeToCoder.
]

{ #category : #'widget configuration' }
GtCoderSideBarSystemNavigationExtension >> fillToolWidgetIn: aCreationContext [
	"initialize a tool widget"
	self sideBar addChild: navigationElement.
]

{ #category : #initialization }
GtCoderSideBarSystemNavigationExtension >> initializeNavigationElement [
	navigationElement := (GtCoderSideBarNavigationPackagesTagsClassesElement new 
		navigationModel: navigationModel).
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
	self sideBar constraintsDo: [ :c | c horizontal matchParent ]
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
