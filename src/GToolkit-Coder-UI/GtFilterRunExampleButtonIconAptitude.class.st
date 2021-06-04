"
I am a {{gtClass:GtFilterRunExampleButtonLook}}.
I display a colored icon that represent an {{gtClass:GtExampleWithResult}} execution and result state.
1. # Examples

The following examples shows a colored icon as a part of a button in four possible states.
1. ## Not Executed Examples

{{gtExample:GtFilterRunExampleButtonLookExamples>>#oneIconLookButton_SkipNoTest|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}}
1. ## Examples With Successful Execution

{{gtExample:GtFilterRunExampleButtonLookExamples>>#oneIconLookButton_Success|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}}
1. ## Examples With Not Satisfying Assertions

{{gtExample:GtFilterRunExampleButtonLookExamples>>#oneIconLookButton_Failure|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}}
1. ## Examples With Execution Errors

{{gtExample:GtFilterRunExampleButtonLookExamples>>#oneIconLookButton_Error|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}}


"
Class {
	#name : #GtFilterRunExampleButtonIconAptitude,
	#superclass : #GtFilterRunExampleButtonAptitude,
	#instVars : [
		'exampleElement'
	],
	#category : #'GToolkit-Coder-UI-Filters'
}

{ #category : #'private - accessing' }
GtFilterRunExampleButtonIconAptitude >> exampleElement [
	<return: #BlElement>
	^ exampleElement
]

{ #category : #initialization }
GtFilterRunExampleButtonIconAptitude >> initialize [
	super initialize.
	self initializeExampleElement.
	
	self addChangeAddChildAs: #(content example) with: [ self exampleElement ].
]

{ #category : #initialization }
GtFilterRunExampleButtonIconAptitude >> initializeExampleElement [
	exampleElement := BlElement new
		background: self newNotExecutedBackground.
	self initializeIconElement: exampleElement.
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconAptitude >> newBackground [
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
GtFilterRunExampleButtonIconAptitude >> newErrorBackground [
	^ GtFilterExampleErrorState default color
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconAptitude >> newFailureBackground [
	^ GtFilterExampleFailureState default color
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconAptitude >> newNotExecutedBackground [
	^ GtFilterExampleNotExecutedState default color
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconAptitude >> newSuccessBackground [
	^ GtFilterExampleSuccessState default color
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonIconAptitude >> updateButtonStatus [
	"I must be called in a UI process".
	self widgetDo: [ :aWidget | 
		self examplerDo: [ :anExampler | 
			| aStatus |
			aStatus := anExampler hasSelectedExecutableExamples.
			aWidget dispatchEvent: (BrEnablementWish enabled: aStatus).
			anExampler hasExamples 
				ifFalse: [ aWidget visibility: BlVisibility gone ]
				ifTrue: [ aWidget visibility: BlVisibility visible] ] ]
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonIconAptitude >> updateExampleStatus [
	"I must be called in a UI process".
	self exampleElement
		background: self newBackground
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonIconAptitude >> updateWidget [
	super updateWidget.
	self updateExampleStatus.
	self updateButtonStatus.
]
