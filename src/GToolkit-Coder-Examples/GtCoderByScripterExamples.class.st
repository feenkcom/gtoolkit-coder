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

{ #category : #utilities }
GtCoderByScripterExamples >> scripterForBlock: aBlock [
	<gtExample>
	| aScripter |
	aScripter := self scripter.
	aScripter substep: 'Initialize Coder Model and UI' do: [ :aStep | 
		aStep set 
			label: 'Initialize Coder Model';
			model: aBlock.
		aStep set 
			label: 'Initialize Coder UI';
			element: [ :aCoder | aCoder asElement ];
			onModel ].
	^ aScripter
]
