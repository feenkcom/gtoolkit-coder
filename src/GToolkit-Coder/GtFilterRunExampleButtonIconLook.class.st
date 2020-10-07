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
	^ BrGlamorousColors neutralBackgroundColor
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconLook >> newSuccessBackground [
	^ BrGlamorousColors successBackgroundColor
]

{ #category : #'private - hooks' }
GtFilterRunExampleButtonIconLook >> onCoderChanged [
	super onCoderChanged.
	self updateWidget.
]

{ #category : #'private - announcement handling' }
GtFilterRunExampleButtonIconLook >> onCoderChanged: aGtCodersCodersChanged [
	super onCoderChanged: aGtCodersCodersChanged.
	self postponeUpdate.
]

{ #category : #'private - announcement handling' }
GtFilterRunExampleButtonIconLook >> onExampleExecuted: aGtCoderExampleExecuted [
	self postponeUpdate.
]

{ #category : #'api - hooks' }
GtFilterRunExampleButtonIconLook >> onInstalledIn: anElement [
	super onInstalledIn: anElement.
	self updateButtonStatus.
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonIconLook >> updateButtonStatus [
	"I must be called in a UI process".
	self widgetDo: [ :aWidget | 
		| aStatus |
		aStatus := self coder exampler hasSelectedExecutableExamples.
		aWidget dispatchEvent: (BrEnablementWish enabled: aStatus).
		self coder exampler hasExamples 
			ifFalse: [ aWidget visibility: BlVisibility gone ]
			ifTrue: [ aWidget visibility: BlVisibility visible] ]
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonIconLook >> updateExampleStatus [
	"I must be called in a UI process".
	self exampleElement
		background: self newBackground
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonIconLook >> updateWidget [
	super updateWidget.
	self updateExampleStatus.
	self updateButtonStatus.
]
