Trait {
	#name : #TCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #'examples - scripter' }
TCoderByScripterExamples >> scripter [
	| scripter |
	scripter := BlDevScripter new.
	
	self assert: scripter events isEmpty.
	
	^ scripter
]

{ #category : #utilities }
TCoderByScripterExamples >> scripterForBlock: aBlock [
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
