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

{ #category : #'examples - one icon look' }
GtFilterRunExampleButtonLookExamples >> basicOneIconLook [
	<gtExample>
	| aLook |
	aLook := GtFilterRunExampleButtonIconLook new.
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

{ #category : #'examples - one icon look' }
GtFilterRunExampleButtonLookExamples >> buttonWithOneIconLook [
	<gtExample>
	| aButton aLook |
	aButton := self button.
	aLook := self basicOneIconLook.
	aButton
		addLook: aLook;
		addLook: BrGlamorousButtonWithIconLook.
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleNotExecutedState default color.
	^ aButton
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> methodsCoder [
	<gtExample>
	^ GtClassMethodsCoder forClass: GtFilterRunExampleButtonLookDummyExamples
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
GtFilterRunExampleButtonLookExamples >> oneExample [
	<gtExample>
	^ (GtFilterRunExampleButtonLookDummyExamples >> #one) gtExample asExampleWithResult
]

{ #category : #'examples - one icon look' }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_Error [
	<gtExample>
	| aLook aButton aCoder |
	aButton := self buttonWithOneIconLook.
	aLook := aButton look.
	aCoder := self methodsCoder.
	aLook coder: aCoder.

	BlUseAsyncFeatures disableDuring: [ 
		aCoder exampler 
			runExamples;
			runNotTestExamples ].
	
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleErrorState default color.
	^ aButton
]

{ #category : #'examples - one icon look' }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_Failure [
	<gtExample>
	| aLook aButton aCoder |
	aButton := self buttonWithOneIconLook.
	aLook := aButton look.
	aCoder := self methodsCoderWithFailingExamples.
	aLook coder: aCoder.

	BlUseAsyncFeatures disableDuring: [ 
		aCoder exampler 
			runExamples;
			runNotTestExamples ].
	
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleFailureState default color.
	^ aButton
]

{ #category : #'examples - one icon look' }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_NotExecuted [
	<gtExample>
	| aLook aButton |
	aButton := self buttonWithOneIconLook.
	aLook := aButton look.
	
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleNotExecutedState default color.
	^ aButton
]

{ #category : #'examples - one icon look' }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_SkipNoTest [
	<gtExample>
	| aLook aButton aCoder |
	aButton := self buttonWithOneIconLook.
	aLook := aButton look.
	aCoder := self methodsCoder.
	aLook coder: aCoder.

	BlUseAsyncFeatures disableDuring: [ 
		aCoder exampler 
			runExamples ].

	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleNotExecutedState default color.
	^ aButton
]

{ #category : #'examples - one icon look' }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_Success [
	<gtExample>
	| aLook aButton aCoder |
	aButton := self buttonWithOneIconLook.
	aLook := aButton look.
	aCoder := self methodsCoderWithSuccessExamples.
	aLook coder: aCoder.

	BlUseAsyncFeatures disableDuring: [ 
		aCoder exampler 
			runExamples;
			runNotTestExamples ].
	
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleSuccessState default color.
	^ aButton
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> threeExample [
	<gtExample>
	^ (GtFilterRunExampleButtonLookDummyExamples >> #three) gtExample asExampleWithResult
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> twoExample [
	<gtExample>
	^ (GtFilterRunExampleButtonLookDummyExamples >> #two) gtExample asExampleWithResult
]
