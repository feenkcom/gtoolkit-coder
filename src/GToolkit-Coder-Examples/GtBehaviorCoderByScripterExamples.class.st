Class {
	#name : #GtBehaviorCoderByScripterExamples,
	#superclass : #Object,
	#traits : 'TCoderByScripterExamples',
	#classTraits : 'TCoderByScripterExamples classTrait',
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #'examples - for class' }
GtBehaviorCoderByScripterExamples >> classCoderForClass [
	<gtExample>
	| anEnvironment aDummyClass aBehaviorCoder |
	
	anEnvironment := GtPharoDummyEnvironment withPackages: 2 classes: 2.
	aDummyClass := anEnvironment anyDummyClass.

	aBehaviorCoder := GtBehaviorCoder forClass: aDummyClass realClass.
	aBehaviorCoder attributeNamed: #dummyEnvironment put: anEnvironment.
	aBehaviorCoder attributeNamed: #dummyClass put: aDummyClass.

	^ aBehaviorCoder
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
				id: GtBehaviorCoder addNewMethodButtonName.
			aStep wait forEmptySpaceTaskQueue.
			
			aStep check
				label: 'Check new method' ].	

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
				id: GtBehaviorCoderBehaviorNameId.

			aStep wait forEmptySpaceTaskQueue.

			aStep check
				label: 'Check class name has focus';
				satisfies: [ :aClassNameEditor | aClassNameEditor hasFocus ];
				id: GtBehaviorCoderBehaviorNameId.
				
			aStep shortcut
				combination: BlKeyCombination primaryC;
				id: GtBehaviorCoderBehaviorNameId.
				
			aStep check
				label: 'Check clipboard has class name';
				value: [ Clipboard clipboardText ] equals: [ :aCoder | (aCoder attributeNamed: #dummyClass) className ];
				onModel
	].
		
	^ aScripter syncContinue
]

{ #category : #'examples - for class' }
GtBehaviorCoderByScripterExamples >> classCoderForClassUI_renameClass_01_doubleClick [
	<gtExample>
	| aScripter |

	aScripter := self classCoderForClassUI.
	
	aScripter
		substep: 'Make class name editable with a double click'
		do: [ :aStep |
			
			aStep doubleClick
				label: 'Click class name';
				id: GtBehaviorCoderBehaviorNameId.

			aStep wait forEmptySpaceTaskQueue.

			aStep check
				label: 'Check class name has focus';
				satisfies: [ :aClassNameEditor | aClassNameEditor hasFocus ];
				id: GtBehaviorCoderBehaviorNameId.
				
			aStep check
				label: 'Check class name is editable';
				satisfies: [ :aClassNameEditor | aClassNameEditor isEditable ];
				id: GtBehaviorCoderBehaviorNameId.
	].
		
	^ aScripter syncContinue
]

{ #category : #'examples - for class' }
GtBehaviorCoderByScripterExamples >> classCoderForClassUI_renameClass_01_shortcut [
	<gtExample>
	| aScripter |

	aScripter := self classCoderForClassUI.
	
	aScripter
		substep: 'Make class name editable with a shortcut'
		do: [ :aStep |
			aStep click
				label: 'Click class name';
				onChildNamed: GtBehaviorCoderBehaviorNameId.

			aStep wait forEmptySpaceTaskQueue.

			aStep check
				label: 'Check class name has focus';
				satisfies: [ :aClassNameEditor | aClassNameEditor hasFocus ];
				id: GtBehaviorCoderBehaviorNameId.
				
			aStep shortcut
				combination: BlKeyCombination primaryR;
				id: GtBehaviorCoderBehaviorNameId.
	
			aStep check
				label: 'Check class name is editable';
				satisfies: [ :aClassNameEditor | aClassNameEditor isEditable ];
				id: GtBehaviorCoderBehaviorNameId.
				
			aStep check
				label: 'Check class name has focus';
				satisfies: [ :aClassNameEditor | aClassNameEditor hasFocus ];
				id: GtBehaviorCoderBehaviorNameId ].
		
	^ aScripter syncContinue
]

{ #category : #'examples - for class' }
GtBehaviorCoderByScripterExamples >> classCoderForClassUI_renameClass_02_type_new_class_name [
	<gtExample>
	| aScripter |

	aScripter := self classCoderForClassUI_renameClass_01_shortcut.
	
	aScripter
		substep: 'Type new class name'
		do: [ :aStep |
			
			aStep check
				label: 'Check apply preview button does not exist yet';
				notExists;
				id: GtBehaviorCoderBehaviorNameApplyPreviewId.
			
			(aStep type: (aScripter model attributeNamed: #dummyClass) className, 'New')
				label: 'Click class name'.

			aStep wait forEmptySpaceTaskQueue.

			aStep check
				label: 'Check class name has focus';
				satisfies: [ :aClassNameEditor | aClassNameEditor hasFocus ];
				id: GtBehaviorCoderBehaviorNameId.

			aStep check
				label: 'Check class name is editable';
				satisfies: [ :aClassNameEditor | aClassNameEditor isEditable ];
				id: GtBehaviorCoderBehaviorNameId.

			aStep check
				label: 'Check entered name';
				value: [ :aClassNameEditor | aClassNameEditor text asString ] equals: [  (aScripter model attributeNamed: #dummyClass) className, 'New' ];
				id: GtBehaviorCoderBehaviorNameId.
			
			aStep check
				label: 'Check apply preview button exists not';
				exists;
				id: GtBehaviorCoderBehaviorNameApplyPreviewId.
				
	].
		
	^ aScripter syncContinue
]

{ #category : #'examples - for class' }
GtBehaviorCoderByScripterExamples >> classCoderForClassUI_renameClass_03_click_rename_preview [
	<gtExample>
	| aScripter |

	aScripter := self classCoderForClassUI_renameClass_02_type_new_class_name.
	
	aScripter
		substep: 'Click rename preview'
		do: [ :aStep |
			
			aStep click
				label: 'Click apply preview button';
				id: GtBehaviorCoderBehaviorNameApplyPreviewId.

			aStep wait forEmptySpaceTaskQueue.
				
	].
		
	^ aScripter syncContinue
]
