Class {
	#name : #GtCoder2,
	#superclass : #BlElement,
	#traits : 'TGtPagerPageInstantiator + TGtPhlowToolDetailAdjustable + TGtWithCoderToolViewModel + TBrLayoutResizable',
	#classTraits : 'TGtPagerPageInstantiator classTrait + TGtPhlowToolDetailAdjustable classTrait + TGtWithCoderToolViewModel classTrait + TBrLayoutResizable classTrait',
	#instVars : [
		'coderContainer',
		'goBackButton',
		'navigationBreacrumb',
		'navigationSidebar'
	],
	#category : #'GToolkit-Coder-UI-! Core'
}

{ #category : #initialization }
GtCoder2 >> createCoderContainer [
	"A container that contains an actual current coder element. The content of the container
	is replaced every time a coder is pushed or popped" 

	^ BrVerticalPane new
		matchParent
]

{ #category : #initialization }
GtCoder2 >> createGoBackButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithLabelAptitude;
		label: 'Go back';
		action: [ self coderToolViewModel popCoderViewModel ]
]

{ #category : #initialization }
GtCoder2 >> createNavigationBreadcrumb [
	^ BrHorizontalPane new
		hMatchParent;
		vFitContent
]

{ #category : #initialization }
GtCoder2 >> createNavigationSidebar [
	^ GtPhlowHorizontalSidebarElement new beLeft
]

{ #category : #initialization }
GtCoder2 >> initialize [
	super initialize.
	
	self layout: BlLinearLayout horizontal.
	self matchParent.

	navigationSidebar := self createNavigationSidebar.

	goBackButton := self createGoBackButton.
	navigationBreacrumb := self createNavigationBreadcrumb.
	navigationBreacrumb addChild: goBackButton.

	coderContainer := self createCoderContainer.

	self addChildren: { 
		navigationSidebar.

		BrVerticalPane new
			matchParent;
			addChildren: {
				navigationBreacrumb.
				coderContainer }
	}.

	self addInteractiveModelState: GtPhlowToolDetailModel new.
	self addAptitude: (GtPhlowToolDetailAptitude new
		normal: [ :theInstance | navigationSidebar hide ];
		detailed: [ :theInstance | navigationSidebar show ]).

	self
		when: GtCoderToReplace
		do: [ :anEvent |
			anEvent consumed: true.
			self coderToolViewModel pushCoderViewModel: anEvent coder asCoderViewModel ].
		
	
]

{ #category : #initialization }
GtCoder2 >> navigationStencil: aStencil [
	navigationSidebar contentStencil: aStencil
]

{ #category : #'api - coder tool view model' }
GtCoder2 >> onCoderToolViewModelChanged [
	"Is sent when a new coderTool view model is assigned to the element.
	Note: #onCoderToolViewModelChanged is sent before #subscribeToCoderToolViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostCoderToolViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"

	self updateGoBackButton.
	self rebuildTopCoderElement
]

{ #category : #'private - event handling' }
GtCoder2 >> onViewModelCoderPopped: anAnnouncement [
	self updateGoBackButton.
	self rebuildTopCoderElement.
]

{ #category : #'private - event handling' }
GtCoder2 >> onViewModelCoderPushed: anAnnouncement [
	self updateGoBackButton.
	self rebuildTopCoderElement
]

{ #category : #opening }
GtCoder2 >> pagerWindowTitle [
	<return: #String>
	^ self shortTitle
]

{ #category : #'private - updating' }
GtCoder2 >> rebuildTopCoderElement [
	coderContainer removeChildren.
	
	self coderToolViewModel hasCoderViewModel
		ifTrue: [ coderContainer addChild: self coderToolViewModel currentCoderViewModel asElement ]
]

{ #category : #'api - coder tool view model' }
GtCoder2 >> subscribeToCoderToolViewModel [
	"Is sent after a new coderTool view model is assigned to the element.
	It is required to unsubscribe from the view model or domain model by implementing
	#unsubscribeFromCoderToolViewModel if elements subscribe to them"

	self coderToolViewModel weak
		when: GtCoderToolViewModelCoderPushed send: #onViewModelCoderPushed: to: self;
		when: GtCoderToolViewModelCoderPopped send: #onViewModelCoderPopped: to: self
]

{ #category : #'api - coder tool view model' }
GtCoder2 >> unsubscribeFromCoderToolViewModel [
	"Is sent before a new coderTool view model is assigned to the element.
	Elements that subscribe to coderTool view model in domain model are required to implement this methods."
	
	self coderToolViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtCoder2 >> updateGoBackButton [
	goBackButton enabled: self coderToolViewModel canGoBack
]
