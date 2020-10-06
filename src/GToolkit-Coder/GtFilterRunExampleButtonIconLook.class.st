Class {
	#name : #GtFilterRunExampleButtonIconLook,
	#superclass : #GtFilterRunExampleButtonLook,
	#instVars : [
		'exampleElement'
	],
	#category : #'GToolkit-Coder-Filters - UI'
}

{ #category : #'private - accessing' }
GtFilterRunExampleButtonIconLook >> exampleElement [
	<return: #BlElement>
	^ exampleElement
]

{ #category : #initialization }
GtFilterRunExampleButtonIconLook >> initialize [
	super initialize.
	self initializeExampleElement.
	
	self addChangeAddChildAs: #(content example) with: [ self exampleElement ].
]

{ #category : #initialization }
GtFilterRunExampleButtonIconLook >> initializeExampleElement [
	exampleElement := BlElement new
		geometry: BlCircle new;
		size: 8@8;
		background: self newNotExecutedBackground
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconLook >> newBackground [
	self coder exampler hasNotExecutedExamples ifTrue: [ 
		^ self newNotExecutedBackground ].
	self coder exampler hasErrorExamples ifTrue: [ 
		^ self newErrorBackground ].
	self coder exampler hasFailureExamples ifTrue: [ 
		^ self newFailureBackground ].
	self coder exampler hasSuccessExamples ifTrue: [ 
		^ self newSuccessBackground ].
	^ self newNotExecutedBackground.
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconLook >> newErrorBackground [
	^ BrGlamorousColors errorBackgroundColor
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconLook >> newFailureBackground [
	^ BrGlamorousColors failureBackgroundColor
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconLook >> newNotExecutedBackground [
	^ BrGlamorousColors defaultButtonBorderColor
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconLook >> newSuccessBackground [
	^ BrGlamorousColors successBorderColor
]

{ #category : #'private - hooks' }
GtFilterRunExampleButtonIconLook >> onCoderChanged [
	super onCoderChanged.
	self updateStatus.
]

{ #category : #'private - announcement handling' }
GtFilterRunExampleButtonIconLook >> onExampleExecuted: aGtCoderExampleExecuted [
	self widgetDo: [ :aWidget | 
		aWidget enqueueTask: (BlTaskAction new action: [
			self updateStatus ]) ]
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonIconLook >> updateStatus [
	"I must be called in a UI process".
	self exampleElement
		background: self newBackground
]
