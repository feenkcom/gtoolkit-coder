Class {
	#name : #GtCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #'examples - scripter' }
GtCoderExamples >> scripter [
	<gtExample>
	| scripter |
	scripter := BlDevScripter new.
	
	self assert: scripter events isEmpty.
	
	^ scripter
]
