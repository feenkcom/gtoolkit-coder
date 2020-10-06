Class {
	#name : #GtFilterRunExampleButtonLook,
	#superclass : #BrLook,
	#instVars : [
		'coder',
		'exampleElement'
	],
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #'api - accessing' }
GtFilterRunExampleButtonLook >> coder [
	<return: #GtSearchMethodsFilter>
	^ coder
]

{ #category : #'api - accessing' }
GtFilterRunExampleButtonLook >> coder: aGtSearchMethodsFilter [
	coder = aGtSearchMethodsFilter ifTrue: [ ^ self ].
	self unsubscribeFromCoder.
	coder := aGtSearchMethodsFilter.
	self subscribeToCoder.
	self onCoderChanged.
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonLook >> exampleElement [
	<return: #BlElement>
	^ exampleElement
]

{ #category : #initialization }
GtFilterRunExampleButtonLook >> initialize [
	super initialize.
	self initializeExampleElement.
	
	self addChangeAddChildAs: #(content example) with: [ self exampleElement ].
]

{ #category : #initialization }
GtFilterRunExampleButtonLook >> initializeExampleElement [
	exampleElement := BlElement new
		geometry: BlCircle new;
		size: 8@8;
		background: self newNotExecutedBackground
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonLook >> newBackground [
	self coder exampler hasErrorExamples ifTrue: [ 
		^ self newErrorBackground ].
	self coder exampler hasFailureExamples ifTrue: [ 
		^ self newFailureBackground ].
	self coder exampler hasSuccessExamples ifTrue: [ 
		^ self newSuccessBackground ].
	^ self newNotExecutedBackground.
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonLook >> newErrorBackground [
	^ BrGlamorousColors errorBackgroundColor
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonLook >> newFailureBackground [
	^ BrGlamorousColors failureBackgroundColor
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonLook >> newNotExecutedBackground [
	^ BrGlamorousColors defaultButtonBorderColor
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonLook >> newSuccessBackground [
	^ BrGlamorousColors successBorderColor
]

{ #category : #'private - hooks' }
GtFilterRunExampleButtonLook >> onCoderChanged [
	self updateStatus.
]

{ #category : #'private - announcement handling' }
GtFilterRunExampleButtonLook >> onExampleExecuted: aGtCoderExampleExecuted [
	self widgetDo: [ :aWidget | 
		aWidget enqueueTask: (BlTaskAction new action: [
			self updateStatus ]) ]
]

{ #category : #'private - subscriptions' }
GtFilterRunExampleButtonLook >> subscribeToCoder [
	self coder weak
		when: GtCoderExampleExecuted
		send: #onExampleExecuted:
		to: self
]

{ #category : #'private - subscriptions' }
GtFilterRunExampleButtonLook >> unsubscribeFromCoder [
	self coder ifNil: [ ^ self ].
	self coder unsubscribe: self.
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonLook >> updateStatus [
	"I must be called in a UI process".
	self exampleElement
		background: self newBackground
]
