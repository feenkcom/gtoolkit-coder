Class {
	#name : #GtSourceCoderBreadcrumbElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #examples }
GtSourceCoderBreadcrumbElementExamples >> breadcrumbForSourceCoder [
	<gtExample>
	| aCoderUIModel aCoderBreadcrumb |
	
	aCoderUIModel := self methodCoderUIModel.

	aCoderBreadcrumb := GtSourceCoderBreadcrumbElement new.
	aCoderBreadcrumb sourceCoderUIModel: aCoderUIModel.
	
	self assert: aCoderBreadcrumb numberOfItems equals: 2.
	self assert: (aCoderBreadcrumb itemAt: 1) model package name equals: #'GToolkit-Coder-Examples'.
	self assert: (aCoderBreadcrumb itemAt: 2) model classOrMetaClass name equals: #'GtBehaviorCoderDummyClass'.
	
	^ aCoderBreadcrumb
]

{ #category : #'instance creation' }
GtSourceCoderBreadcrumbElementExamples >> methodCoder [
	<gtExample>
	
	^ GtMethodCoder forMethod: (GtBehaviorCoderDummyClass >> #instVarB:)
]

{ #category : #examples }
GtSourceCoderBreadcrumbElementExamples >> methodCoderBreadcrumbActions [
	<gtExample>
	| theActions |
	
	theActions := self methodCoder breadcrumbActions.
	
	self assert: theActions first package name equals: #'GToolkit-Coder-Examples'.
	self assert: theActions second classOrMetaClass name equals: #'GtBehaviorCoderDummyClass'.
	
	^ theActions
]

{ #category : #'instance creation' }
GtSourceCoderBreadcrumbElementExamples >> methodCoderUIModel [
	<gtExample>
	
	^ GtSourceCoderUIModel new coder: self methodCoder
]
