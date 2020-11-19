Class {
	#name : #GtSourceCoderEditorElementByScripterExamples,
	#superclass : #GtCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #'example - instance creation' }
GtSourceCoderEditorElementByScripterExamples >> scripterWithElement [
	<gtExample>
	| aScripter |

	aScripter := self scripter.
	aScripter substep: 'Initialize Coder Model and UI' do: [ :aStep | 		
		aStep set
			label: 'Initialize Coder Editor UI';
			element: [ GtSourceCoderEditorElementExamples new editorForExampleMethodCoder ];
			onSelf.

		aStep set
			label: 'Initialize Coder UI Model';
			model: [ :anElement | anElement sourceCoderUIModel ];
			onSelf ].

	^ aScripter syncContinue
]
