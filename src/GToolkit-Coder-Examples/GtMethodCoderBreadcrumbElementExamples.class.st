Class {
	#name : #GtMethodCoderBreadcrumbElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Source Coder - UI'
}

{ #category : #examples }
GtMethodCoderBreadcrumbElementExamples >> breadcrumbForSourceCoder [
	<gtExample>
	| aCoderUIModel aCoderBreadcrumb |
	
	aCoderUIModel := self methodCoderUIModel.

	aCoderBreadcrumb := GtMethodCoderBreadcrumbElement new.
	aCoderBreadcrumb sourceCoderUIModel: aCoderUIModel.
	
	self assert: aCoderBreadcrumb numberOfItems equals: 2.
	self assert: (aCoderBreadcrumb itemAt: 1) model package name equals: #'GToolkit-Coder-Examples'.
	self assert: (aCoderBreadcrumb itemAt: 2) model name equals: #'GtBehaviorCoderDummyClass'.
	
	^ aCoderBreadcrumb
]

{ #category : #'instance creation' }
GtMethodCoderBreadcrumbElementExamples >> methodCoder [
	<gtExample>
	
	^ GtMethodCoder forMethod: (GtBehaviorCoderDummyClass >> #instVarB:)
]

{ #category : #examples }
GtMethodCoderBreadcrumbElementExamples >> methodCoderBreadcrumbActions [
	<gtExample>
	| theActions |
	
	theActions := self methodCoder breadcrumbActions.
	
	self assert: theActions first package name equals: #'GToolkit-Coder-Examples'.
	self assert: theActions second name equals: #'GtBehaviorCoderDummyClass'.
	
	^ theActions
]

{ #category : #'instance creation' }
GtMethodCoderBreadcrumbElementExamples >> methodCoderUIModel [
	<gtExample>
	
	^ GtSourceCoderUIModel new coder: self methodCoder
]
