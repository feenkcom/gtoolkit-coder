"
I exemplify ${class:GtFilterRunExampleButtonLook|expanded=true|show=#gtSubclassesFor:|height=150}$ subclasses:
"
Class {
	#name : #GtFilterRunExampleButtonLookExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Filters - UI'
}

{ #category : #'private - asserting' }
GtFilterRunExampleButtonLookExamples >> assert: anElement backgroundColor: aColor [ 
	self
		assert: anElement background class 
		equals: BlPaintBackground.
	self
		assert: anElement background paint class 
		equals: BlColorPaint.
	self
		assert: anElement background paint color 
		equals: aColor.
]

{ #category : #'private - asserting' }
GtFilterRunExampleButtonLookExamples >> assertFourIconVisibilityIn: anElement success: isSuccessVisible failure: isFailureVisible error: isErrorVisible noExecution: isNoExecutionVisible [
	
	"The four-icon is expected in the second position"
	| aFourIconElement |
	aFourIconElement := (anElement childAt: 2).
	
	self 
		assert: (aFourIconElement childAt: 1) visibility
		equals: (self visibleOrHiddenFrom: isSuccessVisible).
	self 
		assert: (aFourIconElement childAt: 2) visibility
		equals: (self visibleOrHiddenFrom: isFailureVisible).
	self 
		assert: (aFourIconElement childAt: 3) visibility
		equals: (self visibleOrHiddenFrom: isErrorVisible).
	self 
		assert: (aFourIconElement childAt: 4) visibility
		equals: (self visibleOrHiddenFrom: isNoExecutionVisible).
]

{ #category : #'private - asserting' }
GtFilterRunExampleButtonLookExamples >> assertUpdateRequestedState: aBoolean for: anElement [
	| isAttached |
	self assert: anElement aptitude isNotNil.

	isAttached := false.	
	anElement aptitude withAllChildren do: [ :eachLook | 
		(eachLook isKindOf: GtFilterRunExampleButtonAptitude) ifTrue: [ 
			isAttached := true.
			self assert: eachLook isUpdateRequested equals: aBoolean. ] ].
	
	self assert: isAttached description: 'Element must be attached to at least one example look'.
]

{ #category : #'private - asserting' }
GtFilterRunExampleButtonLookExamples >> assertVisibilityIn: anElement oneIcon: isOneIconVisible fourIcon: isFourIconVisible [
	"The one-icon is expected in the first position"
	self 
		assert: (anElement childAt: 1) visibility
		equals: (self visibleOrGoneFrom: isOneIconVisible).
	
	"The fuor-icon is expected in the second position"
	self 
		assert: (anElement childAt: 2) visibility
		equals: (self visibleOrGoneFrom: isFourIconVisible).
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> attachCoder: aCoder toElementLooks: anElement [
	<gtExample>
	| isAttached |
	self assert: anElement aptitude isNotNil.

	isAttached := false.	
	anElement aptitude withAllChildren do: [ :eachLook | 
		(eachLook isKindOf: GtFilterRunExampleButtonAptitude) ifTrue: [ 
			isAttached := true.
			self assert: eachLook isUpdateRequested not description: 'Example button look should NOT be in update requested state'.
			eachLook coder: aCoder.
			self assert: eachLook isUpdateRequested not description: 'Example button look should NOT be in update requested state'. ] ].
	
	self assert: isAttached description: 'Coder must be attached to at least one look'.
	
	^ aCoder
]

{ #category : #'examples - four-icon look' }
GtFilterRunExampleButtonLookExamples >> basicFourIconLook [
	<gtExample>
	| aLook |
	aLook := GtFilterRunExampleButtonFourStateIconAptitude new.
	self assert: aLook exampleElement isNotNil.
	self assert: aLook coder isNil.
	^ aLook
]

{ #category : #'examples - one-icon look' }
GtFilterRunExampleButtonLookExamples >> basicOneIconLook [
	<gtExample>
	| aLook |
	aLook := GtFilterRunExampleButtonIconAptitude new.
	self assert: aLook exampleElement isNotNil.
	self assert: aLook coder isNil.
	^ aLook
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> button [
	<gtExample>
	^ BrButton new
		icon: BrGlamorousIcons play;
		label: 'Run All Examples'
]

{ #category : #'examples - four-icon look' }
GtFilterRunExampleButtonLookExamples >> buttonWithFourIconLook [
	<gtExample>
	| aButton aLook |
	aButton := self button.
	aLook := self basicFourIconLook.
	aButton
		addAptitude: aLook;
		addAptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude;
		addAptitude: GtFilterRunExampleButtonTooltipAptitude.
	
	self assertVisibilityIn: aButton oneIcon: false fourIcon: true.
	^ aButton
]

{ #category : #'examples - one-icon look' }
GtFilterRunExampleButtonLookExamples >> buttonWithOneIconLook [
	<gtExample>
	| aButton aLook |
	aButton := self button.
	aLook := self basicOneIconLook.
	aButton
		addAptitude: aLook;
		addAptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude;
		addAptitude: GtFilterRunExampleButtonTooltipAptitude.
		
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleNotExecutedState default color.
	^ aButton
]

{ #category : #'examples - four-icon look' }
GtFilterRunExampleButtonLookExamples >> fourIconLookButton_AllExecutionStates [
	<gtExample>
	| aButton aCoder |
	aButton := self buttonWithFourIconLook.
	aCoder := self methodsCoder.
	self attachCoder: aCoder toElementLooks: aButton.
	self assertUpdateRequestedState: false for: aButton.

	BlUseAsyncFeatures disableDuring: [
		aCoder exampler 
			runExamples;
			runNoTestExamples ].

	self assertUpdateRequestedState: false for: aButton.
	self assertVisibilityIn: aButton oneIcon: false fourIcon: true.
	self assertFourIconVisibilityIn: aButton success: true failure: true error: true noExecution: false.

	^ aButton
]

{ #category : #'examples - four-icon look' }
GtFilterRunExampleButtonLookExamples >> fourIconLookButton_NoExamples [
	<gtExample>
	| aButton aCoder |
	aButton := self buttonWithFourIconLook.
	aCoder := self methodsCoderWithoutExamples.
	self attachCoder: aCoder toElementLooks: aButton.

	self assertUpdateRequestedState: false for: aButton.

	self assertVisibilityIn: aButton oneIcon: false fourIcon: true.
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleNotExecutedState default color.

	self
		assert: aButton visibility
		equals: BlVisibility gone.
	
	^ aButton
]

{ #category : #'examples - four-icon look' }
GtFilterRunExampleButtonLookExamples >> fourIconLookButton_NoExamples_Examples [
	<gtExample>
	| aButton aCoder |
	aButton := self fourIconLookButton_NoExamples.
	aCoder := self methodsCoder.
	self attachCoder: aCoder toElementLooks: aButton.

	self assertUpdateRequestedState: false for: aButton.

	self assertVisibilityIn: aButton oneIcon: true fourIcon: false.
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleNotExecutedState default color.

	self
		assert: aButton visibility
		equals: BlVisibility visible.
	
	^ aButton
]

{ #category : #'examples - four-icon look' }
GtFilterRunExampleButtonLookExamples >> fourIconLookButton_NotExecuted [
	<gtExample>
	| aButton aCoder |
	aButton := self buttonWithFourIconLook.
	aCoder := self methodsCoder.
	self attachCoder: aCoder toElementLooks: aButton.

	self assertUpdateRequestedState: false for: aButton.

	self assertVisibilityIn: aButton oneIcon: true fourIcon: false.
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleNotExecutedState default color.
		
	^ aButton
]

{ #category : #'examples - four-icon look' }
GtFilterRunExampleButtonLookExamples >> fourIconLookButton_SuccessAndNotExecutedStates [
	<gtExample>
	| aButton aCoder |
	aButton := self buttonWithFourIconLook.
	aCoder := self methodsCoder.
	self attachCoder: aCoder toElementLooks: aButton.

	self assertUpdateRequestedState: false for: aButton.

	BlUseAsyncFeatures disableDuring: [ 
		aCoder exampler 
			runExamples ].

	self assertUpdateRequestedState: false for: aButton.
	self assertVisibilityIn: aButton oneIcon: false fourIcon: true.
	self assertFourIconVisibilityIn: aButton success: true failure: false error: false noExecution: true.

	^ aButton
]

{ #category : #'examples - four-icon look' }
GtFilterRunExampleButtonLookExamples >> fourIconLookButton_WithoutCoder [
	<gtExample>
	| aButton |
	aButton := self buttonWithFourIconLook.
	aButton aptitude - GtFilterRunExampleButtonTooltipAptitude.

	self assertUpdateRequestedState: false for: aButton.
	self assertVisibilityIn: aButton oneIcon: false fourIcon: true.
	self assertFourIconVisibilityIn: aButton success: true failure: true error: true noExecution: true.

	^ aButton
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> methodsCoder [
	<gtExample>
	^ GtClassMethodsCoder forClass: GtFiltersDummyObjectWithAllExampleStates
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> methodsCoderWithFailingExamples [
	<gtExample>
	^ GtClassMethodsCoder forClass: GtFiltersDummyObjectWithFailureExampleStates
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> methodsCoderWithSuccessExamples [
	<gtExample>
	^ GtClassMethodsCoder forClass: GtFiltersDummyObjectWithSuccessExampleStates
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> methodsCoderWithoutExamples [
	<gtExample>
	^ GtClassMethodsCoder forClass: GtFiltersDummyObjectWithNoExampleStates
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> oneExample [
	<gtExample>
	^ (GtFiltersDummyObjectWithAllExampleStates >> #one) gtExample asExampleWithResult
]

{ #category : #'examples - one-icon look' }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_Error [
	<gtExample>
	| aButton aCoder |
	aButton := self buttonWithOneIconLook.
	aCoder := self methodsCoder.
	self attachCoder: aCoder toElementLooks: aButton.

	BlUseAsyncFeatures disableDuring: [ 
		aCoder exampler 
			runExamples;
			runNoTestExamples ].
	
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleErrorState default color.
	^ aButton
]

{ #category : #'examples - one-icon look' }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_Failure [
	<gtExample>
	| aButton aCoder |
	aButton := self buttonWithOneIconLook.
	aCoder := self methodsCoderWithFailingExamples.
	self attachCoder: aCoder toElementLooks: aButton.

	BlUseAsyncFeatures disableDuring: [ 
		aCoder exampler 
			runExamples;
			runNoTestExamples ].
	
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleFailureState default color.
	^ aButton
]

{ #category : #'examples - one-icon look' }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_SkipNoTest [
	<gtExample>
	| aButton aCoder |
	aButton := self buttonWithOneIconLook.
	aCoder := self methodsCoder.
	self attachCoder: aCoder toElementLooks: aButton.

	BlUseAsyncFeatures disableDuring: [ 
		aCoder exampler 
			runExamples ].

	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleNotExecutedState default color.
	^ aButton
]

{ #category : #'examples - one-icon look' }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_Success [
	<gtExample>
	| aButton aCoder |
	aButton := self buttonWithOneIconLook.
	aCoder := self methodsCoderWithSuccessExamples.
	self attachCoder: aCoder toElementLooks: aButton.

	BlUseAsyncFeatures disableDuring: [ 
		aCoder exampler 
			runExamples;
			runNoTestExamples ].
	
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleSuccessState default color.
	^ aButton
]

{ #category : #'examples - one-icon look' }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_WithoutCoder [
	<gtExample>
	| aButton |
	aButton := self buttonWithOneIconLook.
	
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleNotExecutedState default color.
	^ aButton
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> threeExample [
	<gtExample>
	^ (GtFiltersDummyObjectWithAllExampleStates >> #three) gtExample asExampleWithResult
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> twoExample [
	<gtExample>
	^ (GtFiltersDummyObjectWithAllExampleStates >> #two) gtExample asExampleWithResult
]

{ #category : #'private - asserting' }
GtFilterRunExampleButtonLookExamples >> visibleOrGoneFrom: aBoolean [
	^ aBoolean
		ifTrue: [ BlVisibility visible ]
		ifFalse: [ BlVisibility gone ]
]

{ #category : #'private - asserting' }
GtFilterRunExampleButtonLookExamples >> visibleOrHiddenFrom: aBoolean [
	^ aBoolean
		ifTrue: [ BlVisibility visible ]
		ifFalse: [ BlVisibility hidden ]
]
