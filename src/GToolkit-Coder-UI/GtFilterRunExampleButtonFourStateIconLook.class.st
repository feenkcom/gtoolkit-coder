"
I am a ${class:GtFilterRunExampleButtonIconLook}$.
I display a colored icon that represents an ${class:GtExampleWithResult}$ execution and result state.
If there are examples with different execution states, I display several colors.
!! Examples
The following examples show example status icons. 
!!! All States
I display all states at once as follows:
${example:GtFilterRunExampleButtonLookExamples>>#fourIconLookButton_WithoutCoder|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}$
!!! Not Executed Examples
If all examples have same state, only one icon (color) is displayed: ${example:GtFilterRunExampleButtonLookExamples>>#fourIconLookButton_NotExecuted|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}$
!!! Examples With Two Execution States

${example:GtFilterRunExampleButtonLookExamples>>#fourIconLookButton_SuccessAndNotExecutedStates|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}$

"
Class {
	#name : #GtFilterRunExampleButtonFourStateIconLook,
	#superclass : #GtFilterRunExampleButtonIconLook,
	#instVars : [
		'fourIconElement',
		'failureIconElement',
		'errorIconElement',
		'successIconElement',
		'neutralIconElement'
	],
	#category : #'GToolkit-Coder-UI-Filters'
}

{ #category : #'private - accessing' }
GtFilterRunExampleButtonFourStateIconLook >> errorIconElement [
	^ errorIconElement
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonFourStateIconLook >> failureIconElement [
	^ failureIconElement
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonFourStateIconLook >> fourIconElement [
	^ fourIconElement
]

{ #category : #initialization }
GtFilterRunExampleButtonFourStateIconLook >> initialize [
	super initialize.
	self initializeFourStateIconElement.
	self initializeNeutralIconElement.
	self initializeErrorIconElement.
	self initializeFailureIconElement.
	self initializeSuccessIconElement.
	
	self fourIconElement addChild: self successIconElement as: #success.
	self fourIconElement addChild: self failureIconElement as: #failure.
	self fourIconElement addChild: self errorIconElement as: #error.
	self fourIconElement addChild: self neutralIconElement as: #neutral.
	
	self addChangeAddChildAs: #(content fourStateExample) with: [ self fourIconElement ].
]

{ #category : #initialization }
GtFilterRunExampleButtonFourStateIconLook >> initializeErrorIconElement [
	errorIconElement := BlElement new
		background: self newErrorBackground.
	self initializeIconElement: errorIconElement.
]

{ #category : #initialization }
GtFilterRunExampleButtonFourStateIconLook >> initializeExampleElement [
	super initializeExampleElement.
	self exampleElement visibility: BlVisibility gone.
]

{ #category : #initialization }
GtFilterRunExampleButtonFourStateIconLook >> initializeFailureIconElement [
	failureIconElement := BlElement new
		background: self newFailureBackground.
	self initializeIconElement: failureIconElement
]

{ #category : #initialization }
GtFilterRunExampleButtonFourStateIconLook >> initializeFourStateIconElement [
	fourIconElement := BlElement new
		layout: (BlGridLayout new
			columnCount: 2;
			cellSpacing: 0);
		background: BlBackground transparent;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
]

{ #category : #initialization }
GtFilterRunExampleButtonFourStateIconLook >> initializeNeutralIconElement [
	neutralIconElement := BlElement new
		background: self newNotExecutedBackground.
	self initializeIconElement: neutralIconElement.
]

{ #category : #initialization }
GtFilterRunExampleButtonFourStateIconLook >> initializeSuccessIconElement [
	successIconElement := BlElement new
		background: self newSuccessBackground.
	self initializeIconElement: successIconElement
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonFourStateIconLook >> neutralIconElement [
	^ neutralIconElement
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonFourStateIconLook >> successIconElement [
	^ successIconElement
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonFourStateIconLook >> updateFourIconElement [
	| isNeutralVisible isErrorVisible isFailureVisible isSuccessVisible |
	self updateIconElement: self neutralIconElement status: (isNeutralVisible := self exampler hasNotExecutedExamples).
	self updateIconElement: self errorIconElement status: (isErrorVisible := self exampler hasErrorExamples).
	self updateIconElement: self failureIconElement status: (isFailureVisible := self exampler hasFailureExamples).
	self updateIconElement: self successIconElement status: (isSuccessVisible := self exampler hasSuccessExamples).
	isNeutralVisible asBit + isErrorVisible asBit + isFailureVisible asBit + isSuccessVisible asBit = 1
		ifTrue: [ 
			self fourIconElement visibility: BlVisibility gone.
			self exampleElement visibility: BlVisibility visible ] 
		ifFalse: [ 
			self fourIconElement visibility: BlVisibility visible.
			self exampleElement visibility: BlVisibility gone ]
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonFourStateIconLook >> updateIconElement: anElement status: aBoolean [
	aBoolean
		ifTrue: [ 
			anElement visibility: BlVisibility visible ]
		ifFalse: [ 
			anElement visibility: BlVisibility hidden ].
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonFourStateIconLook >> updateWidget [
	super updateWidget.
	self updateFourIconElement.
]
