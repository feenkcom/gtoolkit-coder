Class {
	#name : #GtMethodsCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #accessing }
GtMethodsCoderExamples >> doFilter [
	<gtExample>
	^ GtCoderImplementorsFilter selector: #do:
]

{ #category : #accessing }
GtMethodsCoderExamples >> doImplementorsCoder [
	<gtExample>
	^ (GtCoderMethodsCollection forFilter: self doFilter) asCoder
]

{ #category : #accessing }
GtMethodsCoderExamples >> errorFilter [
	<gtExample>
	^ GtCoderReferencesFilter literal: #error:
]

{ #category : #accessing }
GtMethodsCoderExamples >> errorReferencesCoder [
	<gtExample>
	^ (GtCoderMethodsCollection forFilter: self errorFilter) asCoder
]

{ #category : #accessing }
GtMethodsCoderExamples >> factorialExample [
	<gtExample>
	^ GtProcessCoder forProcess: self suspendedFactorialProcess
]

{ #category : #accessing }
GtMethodsCoderExamples >> gtExamplesCoder [
	<gtExample>
	| methods |
	methods := GtCoderMethodsCollection forFilter: self gtExamplesFilter.
	self assert: (methods includes: thisContext method).
	^ methods asCoder
]

{ #category : #accessing }
GtMethodsCoderExamples >> gtExamplesFilter [
	<gtExample>
	^ GtCoderPragmasFilter forPragma: #gtExample
]

{ #category : #accessing }
GtMethodsCoderExamples >> instanceVariableFilter [
	<gtExample>
	^ GtCoderInstanceVariableReferenceFilter forClass: HashedCollection andVariable: 'array'
]

{ #category : #accessing }
GtMethodsCoderExamples >> instanceVariableReferenceCoder [
	<gtExample>
	^ (GtCoderMethodsCollection forFilter: self instanceVariableFilter) asCoder
]

{ #category : #accessing }
GtMethodsCoderExamples >> intersectionCoder [
	<gtExample>
	^ (GtCoderMethodsCollection forFilter: self instanceVariableFilter & self doFilter) asCoder
]

{ #category : #accessing }
GtMethodsCoderExamples >> methodsCoderWithClass [
	<gtExample>
	^ GtClassMethodsCoder forClass: Object
]

{ #category : #accessing }
GtMethodsCoderExamples >> methodsCoderWithExplicitMethods [
	<gtExample>
	^ GtMethodsCoder forMethods: { Object>>#printString . Object >>#printOn: }
]

{ #category : #accessing }
GtMethodsCoderExamples >> printStringFilter [
	<gtExample>
	^ GtCoderReferencesFilter literal: #printString
]

{ #category : #accessing }
GtMethodsCoderExamples >> suspendedFactorialProcess [
	<gtExample>
	| process |
	process := [ 100000 factorial printString ] newProcess.
	process priority: Processor activePriority - 1.
	process resume.
	(Delay forMilliseconds: 2) wait.
	process suspend.
	^ process
]

{ #category : #accessing }
GtMethodsCoderExamples >> unionCoder [
	<gtExample>
	^ (GtCoderMethodsCollection forFilter: self errorFilter | self printStringFilter) asCoder
]

{ #category : #accessing }
GtMethodsCoderExamples >> validateNoMemoryLeaks [
	<gtExample>
	| subscriptionCount instanceCount diffSubscriptions diffInstances |
	Smalltalk garbageCollect.
	subscriptionCount := SystemAnnouncer uniqueInstance numberOfSubscriptions.
	instanceCount := GtCoderMethodsCollection allInstances size.
	10 timesRepeat: [ self doImplementorsCoder ].
	3 timesRepeat: [ Smalltalk garbageCollect ].
	diffSubscriptions := subscriptionCount - SystemAnnouncer uniqueInstance numberOfSubscriptions.
	diffInstances := instanceCount - GtCoderMethodsCollection allInstances size.
	self assert: diffSubscriptions >= 0.
	self assert: diffInstances >= 0.
	^ {diffSubscriptions.
	diffInstances}
]
