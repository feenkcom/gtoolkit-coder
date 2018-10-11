Class {
	#name : #GtMethodsCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #accessing }
GtMethodsCoderExamples >> factorialExample [
	<gtExample>
	| process |
	process := [ 100000 factorial printString ] newProcess.
	process priority: Processor activePriority - 1.
	process resume.
	(Delay forMilliseconds: 2) wait.
	process suspend.
	^ GtMethodsCoder forProcess: process
]

{ #category : #accessing }
GtMethodsCoderExamples >> methodsCoderWithClass [
	<gtExample>
	^ GtMethodsCoder forClass: Object
]

{ #category : #accessing }
GtMethodsCoderExamples >> methodsCoderWithExplicitMethods [
	<gtExample>
	^ GtMethodsCoder forMethods: { Object>>#printString . Object >>#printOn: }
]
