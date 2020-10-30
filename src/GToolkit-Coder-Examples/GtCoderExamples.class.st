Class {
	#name : #GtCoderExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-Basic'
}

{ #category : #'examples - scripter' }
GtCoderExamples >> scripter [
	<gtExample>
	| scripter |
	scripter := BlDevScripter new.
	
	self assert: scripter events isEmpty.
	
	^ scripter
]
