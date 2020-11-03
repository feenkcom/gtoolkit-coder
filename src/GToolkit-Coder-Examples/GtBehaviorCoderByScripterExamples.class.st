Class {
	#name : #GtBehaviorCoderByScripterExamples,
	#superclass : #GtCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #'examples - for class' }
GtBehaviorCoderByScripterExamples >> classCoderForClass [
	<gtExample>
	
	^ GtBehaviorCoder forClass: self targetClass
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

{ #category : #'examples - for class' }
GtBehaviorCoderByScripterExamples >> classCoderForClassUI_copyClassName [
	<gtExample>
	| aScripter |

	aScripter := self classCoderForClassUI.
	
	aScripter
		substep: 'Copy class name with a shortcut'
		do: [ :aStep |
			aStep click
				label: 'Click class name';
				onChildNamed: GtBehaviorCoder behaviorNameEditorName.

			aStep wait forEmptySpaceTaskQueue.

			aStep check
				label: 'Check class name has focus';
				satisfies: [ :aClassNameEditor | aClassNameEditor hasFocus ];
				onChildNamed: GtBehaviorCoder behaviorNameEditorName.
				
			aStep shortcut
				combination: BlKeyCombination primaryC;
				onChildNamed: GtBehaviorCoder behaviorNameEditorName.
				
			aStep check
				label: 'Check clipboard has class name';
				value: [ Clipboard clipboardText ] equals: self targetClass name
	].
		
	^ aScripter syncContinue
]

{ #category : #'examples - for class' }
GtBehaviorCoderByScripterExamples >> classCoderForClassUI_editClassName [
	<gtExample>
	| aScripter |

	aScripter := self classCoderForClassUI.
	
	aScripter
		substep: 'Make class name editable with a shortcut'
		do: [ :aStep |
			aStep click
				label: 'Click class name';
				onChildNamed: GtBehaviorCoder behaviorNameEditorName.

			aStep wait forEmptySpaceTaskQueue.

			aStep check
				label: 'Check class name has focus';
				satisfies: [ :aClassNameEditor | aClassNameEditor hasFocus ];
				onChildNamed: GtBehaviorCoder behaviorNameEditorName.
				
			aStep shortcut
				combination: BlKeyCombination primaryR;
				onChildNamed: GtBehaviorCoder behaviorNameEditorName.
				
			aStep check
				label: 'Check class name is editable';
				satisfies: [ :aClassNameEditor | aClassNameEditor isEditable ];
				onChildNamed: GtBehaviorCoder behaviorNameEditorName.
				
			aStep check
				label: 'Check class name has focus';
				satisfies: [ :aClassNameEditor | aClassNameEditor hasFocus ];
				onChildNamed: GtBehaviorCoder behaviorNameEditorName.
	].
		
	^ aScripter syncContinue
]

{ #category : #'examples - for class' }
GtBehaviorCoderByScripterExamples >> targetClass [
	^ GtBehaviorCoderDummyClass
]
