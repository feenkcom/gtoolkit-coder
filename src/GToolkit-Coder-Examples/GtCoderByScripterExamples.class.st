Class {
	#name : #GtCoderByScripterExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #'examples - scripter' }
GtCoderByScripterExamples >> scripter [
	<gtExample>
	| scripter |
	scripter := BlDevScripter new.
	
	self assert: scripter events isEmpty.
	
	^ scripter
]
