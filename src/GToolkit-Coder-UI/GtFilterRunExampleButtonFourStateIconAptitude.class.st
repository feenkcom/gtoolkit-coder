"
I am a {{gtClass:GtFilterRunExampleButtonIconLook}}.
I display a colored icon that represents an {{gtClass:GtExampleWithResult}} execution and result state.
If there are examples with different execution states, I display several colors.
1. # Examples

The following examples show example status icons. 
1. ## All States

I display all states at once as follows:
{{gtExample:GtFilterRunExampleButtonLookExamples>>#fourIconLookButton_WithoutCoder|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}}
1. ## Not Executed Examples

If all examples have same state, only one icon (color) is displayed: {{gtExample:GtFilterRunExampleButtonLookExamples>>#fourIconLookButton_NotExecuted|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}}
1. ## Examples With Two Execution States


{{gtExample:GtFilterRunExampleButtonLookExamples>>#fourIconLookButton_SuccessAndNotExecutedStates|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}}


"
Class {
	#name : #GtFilterRunExampleButtonFourStateIconAptitude,
	#superclass : #GtFilterRunExampleButtonIconAptitude,
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
GtFilterRunExampleButtonFourStateIconAptitude >> errorIconElement [
	^ errorIconElement
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonFourStateIconAptitude >> failureIconElement [
	^ failureIconElement
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonFourStateIconAptitude >> fourIconElement [
	^ fourIconElement
]

{ #category : #initialization }
GtFilterRunExampleButtonFourStateIconAptitude >> initialize [
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
GtFilterRunExampleButtonFourStateIconAptitude >> initializeErrorIconElement [
	errorIconElement := BlElement new
		background: self newErrorBackground.
	self initializeIconElement: errorIconElement.
]

{ #category : #initialization }
GtFilterRunExampleButtonFourStateIconAptitude >> initializeExampleElement [
	super initializeExampleElement.
	self exampleElement visibility: BlVisibility gone.
]

{ #category : #initialization }
GtFilterRunExampleButtonFourStateIconAptitude >> initializeFailureIconElement [
	failureIconElement := BlElement new
		background: self newFailureBackground.
	self initializeIconElement: failureIconElement
]

{ #category : #initialization }
GtFilterRunExampleButtonFourStateIconAptitude >> initializeFourStateIconElement [
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
GtFilterRunExampleButtonFourStateIconAptitude >> initializeNeutralIconElement [
	neutralIconElement := BlElement new
		background: self newNotExecutedBackground.
	self initializeIconElement: neutralIconElement.
]

{ #category : #initialization }
GtFilterRunExampleButtonFourStateIconAptitude >> initializeSuccessIconElement [
	successIconElement := BlElement new
		background: self newSuccessBackground.
	self initializeIconElement: successIconElement
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonFourStateIconAptitude >> neutralIconElement [
	^ neutralIconElement
]

{ #category : #'private - accessing' }
GtFilterRunExampleButtonFourStateIconAptitude >> successIconElement [
	^ successIconElement
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonFourStateIconAptitude >> updateFourIconElement [
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
GtFilterRunExampleButtonFourStateIconAptitude >> updateIconElement: anElement status: aBoolean [
	aBoolean
		ifTrue: [ 
			anElement visibility: BlVisibility visible ]
		ifFalse: [ 
			anElement visibility: BlVisibility hidden ].
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonFourStateIconAptitude >> updateWidget [
	super updateWidget.
	self updateFourIconElement.
]
