"
I exemplify ${class:GtCoderExampleStateElement}$.
"
Class {
	#name : #GtCoderExampleStateElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #accessing }
GtCoderExampleStateElementExamples >> assert: anElement backgroundColor: aColor [ 
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

{ #category : #accessing }
GtCoderExampleStateElementExamples >> basicExampleStatusElement [
	<gtExample>
	| anElement |
	anElement := GtCoderExampleStateElement new.
	self assert: anElement example isNil.
	self assert: anElement exampleResult isNil.
	^ anElement
]

{ #category : #accessing }
GtCoderExampleStateElementExamples >> errorExample [
	<gtExample>
	^ (self class >>#three) gtExample asExampleWithResult
]

{ #category : #accessing }
GtCoderExampleStateElementExamples >> exampleStateElement_Error [
	<gtExample>
	| anElement anExample |
	anElement := self basicExampleStatusElement.
	anExample := self errorExample.
	anElement example: anExample.
	
	self assert: anElement example equals: anExample.

	BlUseAsyncFeatures disableDuring: [
		anExample run ].

	self assert: anElement exampleResult isNotNil.
	self assert: anElement exampleResult isError.
	self 
		assert: anElement 
		backgroundColor: GtFilterExampleErrorState default color.
	^ anElement
]

{ #category : #accessing }
GtCoderExampleStateElementExamples >> exampleStateElement_Failure [
	<gtExample>
	| anElement anExample |
	anElement := self basicExampleStatusElement.
	anExample := self failingExample.
	anElement example: anExample.
	
	self assert: anElement example equals: anExample.

	BlUseAsyncFeatures disableDuring: [
		anExample run ].

	self assert: anElement exampleResult isNotNil.
	self assert: anElement exampleResult isFailure.
	self 
		assert: anElement 
		backgroundColor: GtFilterExampleFailureState default color.
	^ anElement
]

{ #category : #accessing }
GtCoderExampleStateElementExamples >> exampleStateElement_NotExecuted [
	<gtExample>
	| anElement anExample |
	anElement := self basicExampleStatusElement.
	anExample := self successExample.
	anElement example: anExample.
	self assert: anElement example equals: anExample.
	self assert: anElement exampleResult isNil.
	self 
		assert: anElement 
		backgroundColor: GtFilterExampleNotExecutedState default color.
	^ anElement
]

{ #category : #accessing }
GtCoderExampleStateElementExamples >> exampleStateElement_Success [
	<gtExample>
	| anElement anExample |
	anElement := self exampleStateElement_NotExecuted.
	anExample := anElement example.
	BlUseAsyncFeatures disableDuring: [
		anExample run ].
	self assert: anElement exampleResult isNotNil.
	self assert: anElement exampleResult isSuccess.
	self 
		assert: anElement 
		backgroundColor: GtFilterExampleSuccessState default color.
	^ anElement
]

{ #category : #accessing }
GtCoderExampleStateElementExamples >> failingExample [
	<gtExample>
	^ (self class >>#two) gtExample asExampleWithResult
]

{ #category : #accessing }
GtCoderExampleStateElementExamples >> one [
	<gtExample>
	^ 1
]

{ #category : #accessing }
GtCoderExampleStateElementExamples >> successExample [
	<gtExample>
	^ (self class >>#one) gtExample asExampleWithResult
]

{ #category : #accessing }
GtCoderExampleStateElementExamples >> three [
	<gtExample>
	<noTest>
	^ 1/0
]

{ #category : #accessing }
GtCoderExampleStateElementExamples >> two [
	<gtExample>
	<noTest>
	self assert: false
]
