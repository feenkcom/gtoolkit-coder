Class {
	#name : #GtBehaviorCoderByScripterExamples,
	#superclass : #GtCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #'examples - for class' }
GtBehaviorCoderByScripterExamples >> classCoderForClass [
	<gtExample>
	
	^ GtBehaviorCoder forClass: GtBehaviorCoderDummyClass
]

{ #category : #'examples - for class' }
GtBehaviorCoderByScripterExamples >> classCoderForClassUI [
	<gtExample>
	| aScripter |

	aScripter := self scripterForBlock: [ self classCoderForClass ].
	^ aScripter syncContinue
]

{ #category : #'examples - for class' }
GtBehaviorCoderByScripterExamples >> classCoderForClassUI_click_add_method [
	<gtExample>
	<noTest>
	| aScripter |

	aScripter := self classCoderForClassUI.
	
	aScripter
		substep: 'Add new method'
		do: [ :aStep |
			aStep click
				label: 'Click add method button';
				onChildNamed: GtBehaviorCoder addNewMethodButtonName.
			aStep wait forEmptySpaceTaskQueue.
			
			aStep check
				label: 'Check new method'
			 ].

	^ aScripter syncContinue
]
