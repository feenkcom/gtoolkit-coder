"
I am a ${class:GtFilterRunExampleButtonLook}$.
I display a colored icon that represent an ${class:GtExampleWithResult}$ execution and result state.
!! Examples
The following examples shows a colored icon as a part of a button in four possible states.
!!! Not Executed Examples
${example:GtFilterRunExampleButtonLookExamples>>#oneIconLookButton_SkipNoTest|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}$
!!! Examples With Successful Execution
${example:GtFilterRunExampleButtonLookExamples>>#oneIconLookButton_Success|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}$
!!! Examples With Not Satisfying Assertions
${example:GtFilterRunExampleButtonLookExamples>>#oneIconLookButton_Failure|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}$
!!! Examples With Execution Errors
${example:GtFilterRunExampleButtonLookExamples>>#oneIconLookButton_Error|codeExpanded=false|previewExpanded=true|previewShow=#gtLiveFor:|previewHeight=65}$

"
Class {
	#name : #GtFilterRunExampleButtonIconLook,
	#superclass : #GtFilterRunExampleButtonLook,
	#instVars : [
		'exampleElement'
	],
	#category : #'GToolkit-Coder-UI-Filters'
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
		background: self newNotExecutedBackground.
	self initializeIconElement: exampleElement.
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
	^ GtFilterExampleErrorState default color
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconLook >> newFailureBackground [
	^ GtFilterExampleFailureState default color
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconLook >> newNotExecutedBackground [
	^ GtFilterExampleNotExecutedState default color
]

{ #category : #'private - instance creation' }
GtFilterRunExampleButtonIconLook >> newSuccessBackground [
	^ GtFilterExampleSuccessState default color
]

{ #category : #'private - updating' }
GtFilterRunExampleButtonIconLook >> updateButtonStatus [
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
