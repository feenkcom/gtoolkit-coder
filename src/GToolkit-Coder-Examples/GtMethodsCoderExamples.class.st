Class {
	#name : #GtMethodsCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #'examples - filters' }
GtMethodsCoderExamples >> doFilter [
	<gtExample>
	^ GtSearchImplementorsFilter selector: #do:
]

{ #category : #'examples - coder' }
GtMethodsCoderExamples >> doImplementorsCoder [
	<gtExample>
	^ (GtSearchMethodGroupResult forFilter: self doFilter) asCoder
]

{ #category : #'examples - filters' }
GtMethodsCoderExamples >> errorFilter [
	<gtExample>
	^ GtSearchReferencesFilter literal: #error:
]

{ #category : #'examples - coder' }
GtMethodsCoderExamples >> errorReferencesCoder [
	<gtExample>
	^ (GtSearchMethodGroupResult forFilter: self errorFilter) asCoder
]

{ #category : #accessing }
GtMethodsCoderExamples >> exceptionProcessCoderExample [
	<gtExample>
	^ GtProcessCoder forProcess: self suspendedErrorProcess
]

{ #category : #accessing }
GtMethodsCoderExamples >> factorialExample [
	<gtExample>
	^ GtProcessCoder forProcess: self suspendedFactorialProcess
]

{ #category : #'examples - coder' }
GtMethodsCoderExamples >> gtExamplesCoder [
	<gtExample>
	| methods |
	methods := GtSearchMethodGroupResult forFilter: self gtExamplesFilter.
	self assert: (methods includes: thisContext method).
	^ methods asCoder
]

{ #category : #'examples - filters' }
GtMethodsCoderExamples >> gtExamplesFilter [
	<gtExample>
	^ #gtExample gtPragmas
]

{ #category : #'examples - filters' }
GtMethodsCoderExamples >> instanceVariableFilter [
	<gtExample>
	^ GtSearchInstanceVariableReferenceFilter forClass: HashedCollection andVariable: 'array'
]

{ #category : #'examples - coder' }
GtMethodsCoderExamples >> instanceVariableReferenceCoder [
	<gtExample>
	^ (GtSearchMethodGroupResult forFilter: self instanceVariableFilter) asCoder
]

{ #category : #'examples - coder' }
GtMethodsCoderExamples >> intersectionCoder [
	<gtExample>
	^ (GtSearchMethodGroupResult forFilter: self instanceVariableFilter & self doFilter) asCoder
]

{ #category : #'examples - class coder' }
GtMethodsCoderExamples >> methodsCoderWithClass [
	<gtExample>
	| classCoder |
	classCoder :=  GtClassMethodsCoder forClass: Object.
	
	self assert: classCoder classOrMetaClass equals: Object.
	self assert: classCoder object equals: nil.
	
	^ classCoder
]

{ #category : #'examples - coder' }
GtMethodsCoderExamples >> methodsCoderWithExplicitMethods [
	<gtExample>
	^ GtMethodsCoder forMethods: { Object>>#printString . Object >>#printOn: }
]

{ #category : #'examples - filters' }
GtMethodsCoderExamples >> printStringFilter [
	<gtExample>
	^ GtSearchReferencesFilter literal: #printString
]

{ #category : #'examples - filters' }
GtMethodsCoderExamples >> selectFilter [
	<gtExample>
	^ self doFilter select: [ :each | (each methodClass includesBehavior: Collection) not ]
]

{ #category : #accessing }
GtMethodsCoderExamples >> suspendedErrorProcess [
	<gtExample>
	| process exception |
	process := [ [ (RBParser parseRewriteExpression: '`{:node | 42 error: 7 error: node + 1}')
		match: thisContext method ast
		inContext: Dictionary new ]
		on: Error
		do: [ :ex | 
			exception := ex.
			ex freeze.
			process suspend ] ] newProcess.
	process priority: Processor activePriority - 1.
	process resume.
	[ exception isNil ] whileTrue: [ (Delay forMilliseconds: 1) wait ].
	^ process
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

{ #category : #'examples - coder' }
GtMethodsCoderExamples >> unionCoder [
	<gtExample>
	^ (GtSearchMethodGroupResult forFilter: self errorFilter | self printStringFilter) asCoder
]

{ #category : #accessing }
GtMethodsCoderExamples >> validateNoMemoryLeaks [
	<gtExample>
	| subscriptionCount instanceCount diffSubscriptions diffInstances |
	Smalltalk garbageCollect.
	subscriptionCount := SystemAnnouncer uniqueInstance numberOfSubscriptions.
	instanceCount := GtSearchMethodGroupResult allInstances size.
	10 timesRepeat: [ self doImplementorsCoder ].
	3 timesRepeat: [ Smalltalk garbageCollect ].
	diffSubscriptions := subscriptionCount - SystemAnnouncer uniqueInstance numberOfSubscriptions.
	diffInstances := instanceCount - GtSearchMethodGroupResult allInstances size.
	self assert: diffSubscriptions >= 0.
	self assert: diffInstances >= 0.
	^ {diffSubscriptions.
	diffInstances}
]
