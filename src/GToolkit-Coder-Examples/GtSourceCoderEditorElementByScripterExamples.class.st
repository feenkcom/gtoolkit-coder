Class {
	#name : #GtSourceCoderEditorElementByScripterExamples,
	#superclass : #GtCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #'example - instance creation' }
GtSourceCoderEditorElementByScripterExamples >> scripterElement [
	<gtExample>
	| aMethodCoder aMethodCoderUIModel anEditorElement |
	
	aMethodCoder := GtMethodCoderExamples new forExampleMethodCoder.
	aMethodCoderUIModel := aMethodCoder asCoderUIModel.
	
	self assert: aMethodCoder addOns shouldBeUpdated.
	BlUseAsyncFeatures disableDuring: [ anEditorElement := GtSourceCoderEditorElement new sourceCoderUIModel: aMethodCoderUIModel ].
	self assert: aMethodCoder addOns shouldBeUpdated not.
	
	self assert: anEditorElement hasFocus not.
	
	^ anEditorElement
]

{ #category : #'example - instance creation' }
GtSourceCoderEditorElementByScripterExamples >> scripterWithElement [
	<gtExample>
	| aScripter |
	
	aScripter := self scripter.
	aScripter substep: 'Initialize Coder Model and UI' do: [ :aStep | 		
		aStep set 
			label: 'Initialize Coder Editor UI';
			element: [ self scripterElement ];
			onSelf.
	
		aStep set 
			label: 'Initialize Coder UI Model';
			model: [ :anElement | anElement sourceCoderUIModel ];
			onSelf ].

	^ aScripter syncContinue
]
