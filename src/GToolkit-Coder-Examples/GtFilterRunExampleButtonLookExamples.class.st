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

{ #category : #'examples - looks' }
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

{ #category : #'examples - looks' }
GtFilterRunExampleButtonLookExamples >> buttonWithOneLook [
	<gtExample>
	| aButton aLook |
	aButton := self button.
	aLook := self basicOneIconLook.
	aButton
		addLook: aLook;
		addLook: BrGlamorousButtonWithIconLook.
	^ aButton
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> methodsCoder [
	<gtExample>
	^ GtClassMethodsCoder forClass: GtFilterRunExampleButtonLookDummyExamples
]

{ #category : #'examples - support' }
GtFilterRunExampleButtonLookExamples >> oneExample [
	<gtExample>
	^ (GtFilterRunExampleButtonLookDummyExamples >> #one) gtExample asExampleWithResult
]

{ #category : #'examples - looks' }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton [
	<gtExample>
	| aLook aButton |
	aButton := self button.
	aLook := self basicOneIconLook.
	aButton addLook: aLook.
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleNotExecutedState default color.
	^ aButton
]

{ #category : #accessing }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_Error [
	<gtExample>
	| aLook aButton aCoder |
	aButton := self buttonWithOneLook.
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

{ #category : #'examples - looks' }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_NotExecuted [
	<gtExample>
	| aLook aButton |
	aButton := self buttonWithOneLook.
	aLook := aButton look.
	
	self 
		assert: (aButton childAt: 1) 
		backgroundColor: GtFilterExampleNotExecutedState default color.
	^ aButton
]

{ #category : #accessing }
GtFilterRunExampleButtonLookExamples >> oneIconLookButton_SkipNoTest [
	<gtExample>
	| aLook aButton aCoder |
	aButton := self buttonWithOneLook.
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
