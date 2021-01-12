Class {
	#name : #GtSourceCoderEditorElementByScripterExamples,
	#superclass : #GtCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #'example - play example' }
GtSourceCoderEditorElementByScripterExamples >> playExample [
	<gtExample>
	<noTest>
	| aScripter |

	aScripter := self scripterWithElement.
	
	aScripter substep: 'Play example' do: [ :aStep | 
		
		aStep check
			label: 'Check gray example status';
			value: [ :aStateElement | 
				aStateElement background paint color ]
			equals: GtFilterExampleNotExecutedState default color;
			onBreadthFirstChildOfClass: GtCoderExampleStateElement.
	
		aStep do
			label: 'Play button from model';
			block: [ :aUIModel | aUIModel coder playExample ];
			onModel.
		
		aStep check
			label: 'Check green example status';
			value: [ :aStateElement | 
				aStateElement background paint color ]
			equals: GtFilterExampleSuccessState default color;
			onBreadthFirstChildOfClass: GtCoderExampleStateElement.
			
		aStep wait forEmptySpaceTaskQueue.
			
		aStep check
			label: 'Check green example status after all actions (styling)';
			value: [ :aStateElement | 
				aStateElement background paint color ]
			equals: GtFilterExampleSuccessState default color;
			onBreadthFirstChildOfClass: GtCoderExampleStateElement.

	].

	^ aScripter syncContinue
]

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
