Class {
	#name : #GtCreateBehaviorElementByScripterExamples,
	#superclass : #GtCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #'examples - instance creation' }
GtCreateBehaviorElementByScripterExamples >> behaviorCreatorForClass [
	<gtExample>
	
	^ GtCreateBehaviorElement new
		forClassDefinition;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ]
]

{ #category : #'private - checks' }
GtCreateBehaviorElementByScripterExamples >> checkClassExists: aClassName [
]

{ #category : #'examples - class creator' }
GtCreateBehaviorElementByScripterExamples >> checkDefaultCreatorForClass [
	<gtExample>
	| aScripter |
	
	aScripter := self scripterForClass.
	
	aScripter substep: 'Check initial state of the class creator' do: [ :aStep | 
		aStep check
			label: 'Check default new class name';
			value: [ :aNameEditor | aNameEditor text asString ] equals: 'NameOfSubclass';
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
	
		aStep check
			label: 'Check default superclass name';
			value: [ :aNameEditor | aNameEditor text asString ] equals: 'Object';
			onChildNamed: GtCodeDefinition behaviorSuperclassEditorName.
			
		aStep check
			label: 'Check default package name';
			value: [ :aNameEditor | aNameEditor text asString ] equals: '';
			onChildNamed: GtCodeDefinition packageEditorName.
			
		aStep check
			label: 'Check default tag name';
			value: [ :aNameEditor | aNameEditor text asString ] equals: '';
			onChildNamed: GtCodeDefinition tagEditorName.
			
		aStep check
			label: 'Check default traits';
			value: [ :aTagger | aTagger tagNames asArray ] equals: #();
			onChildNamed: GtCodeDefinition traitsEditorName.
			
		aStep check
			label: 'Check default slots';
			value: [ :aTagger | aTagger tagNames asArray ] equals: #();
			onChildNamed: GtCodeDefinition slotsEditorName.
			
		aStep check
			label: 'Check default class variables';
			value: [ :aTagger | aTagger tagNames asArray ] equals: #();
			onChildNamed: GtCodeDefinition classVariablesEditorName.
			
		aStep check
			label: 'Check default shared pools';
			value: [ :aTagger | aTagger tagNames asArray ] equals: #();
			onChildNamed: GtCodeDefinition poolsEditorName.

		aStep check
			label: 'Check save button is disabled';
			satisfies: [ :aButton | aButton isDisabled ];
			onChildNamed: GtCreateBehaviorElement saveButtonName ].

	^ aScripter syncContinue
]

{ #category : #'private - checks' }
GtCreateBehaviorElementByScripterExamples >> classExists: aClassName [
	^ self class environment includesKey: aClassName
]

{ #category : #'private - checks' }
GtCreateBehaviorElementByScripterExamples >> classNamed: aClassName [
	^ self class environment at: aClassName
]

{ #category : #'private - setup' }
GtCreateBehaviorElementByScripterExamples >> cleanUp [
	<script: 'self new cleanUp'>
	
	self class environment
		at: self newClassName
		ifPresent: [ :aClass | aClass removeFromSystem ].
		
	(RPackageOrganizer default packageNamed: self newPackageName ifAbsent: [ ^ self ]) removeFromSystem
]

{ #category : #'private - setup' }
GtCreateBehaviorElementByScripterExamples >> newClassName [
	^ #GtCreateBehaviorElementByScripterNewClass
]

{ #category : #'private - setup' }
GtCreateBehaviorElementByScripterExamples >> newPackageName [
	^ #'GtCreateBehaviorElementByScripterNew-Package'
]

{ #category : #'private - setup' }
GtCreateBehaviorElementByScripterExamples >> newTagName [
	^ #'Tag'
]

{ #category : #'examples - class creator' }
GtCreateBehaviorElementByScripterExamples >> saveClassWithName [
	<gtExample>
	<after: #cleanUp>
	| aScripter |

	aScripter := self typeNewClassNameForClass.
	
	aScripter substep: 'Save class with just name' do: [ :aStep | 
		aStep click
			onChildNamed: GtCreateBehaviorElement saveButtonName.
		
		aStep check
			label: 'New class does not exist';
			satisfies: [ (self classExists: self newClassName) not ];
			onScripter.
	].

	^ aScripter syncContinue
]

{ #category : #'examples - class creator' }
GtCreateBehaviorElementByScripterExamples >> saveClassWithNamePackage [
	<gtExample>
	<after: #cleanUp>
	| aScripter |

	aScripter := self typeNewClassNamePackageForClass.
	
	aScripter substep: 'Save class with name and package' do: [ :aStep | 
		aStep click
			onChildNamed: GtCreateBehaviorElement saveButtonName.
		
		aStep check
			label: 'New class exists';
			satisfies: [ self classExists: self newClassName ];
			onScripter.
			
		aStep set
			label: 'Set new class definition as model';
			model: [ GtBehaviorDefinition fromBehavior: (self classNamed: self newClassName) ].
			
		aStep check
			label: 'Check class name';
			value: [ :aDefinition | aDefinition name ] equals: self newClassName;
			onModel.
		
		aStep check
			label: 'Check superclass name';
			value: [ :aDefinition | aDefinition instanceSideDefinition superclass name ] equals: 'Object';
			onModel.
			
		aStep check
			label: 'Check package name';
			value: [ :aDefinition | aDefinition instanceSideDefinition category package name ] equals: self newPackageName;
			onModel.
			
		aStep check
			label: 'Check tag name';
			value: [ :aDefinition | aDefinition instanceSideDefinition category tag name ] equals: '';
			onModel.
	].

	^ aScripter syncContinue
]

{ #category : #'examples - class creator' }
GtCreateBehaviorElementByScripterExamples >> saveClassWithNamePackageTag [
	<gtExample>
	<after: #cleanUp>
	| aScripter |

	aScripter := self typeNewClassNamePackageTagForClass.
	
	aScripter substep: 'Save class with name, package and tag' do: [ :aStep | 
		aStep click
			onChildNamed: GtCreateBehaviorElement saveButtonName.
		
		aStep check
			label: 'New class exists';
			satisfies: [ self classExists: self newClassName ];
			onScripter.
			
		aStep set
			label: 'Set new class definition as model';
			model: [ GtBehaviorDefinition fromBehavior: (self classNamed: self newClassName) ].
			
		aStep check
			label: 'Check class name';
			value: [ :aDefinition | aDefinition name ] equals: self newClassName;
			onModel.
		
		aStep check
			label: 'Check superclass name';
			value: [ :aDefinition | aDefinition instanceSideDefinition superclass name ] equals: 'Object';
			onModel.
			
		aStep check
			label: 'Check package name';
			value: [ :aDefinition | aDefinition instanceSideDefinition category package name ] equals: self newPackageName;
			onModel.
			
		aStep check
			label: 'Check tag name';
			value: [ :aDefinition | aDefinition instanceSideDefinition category tag name ] equals: self newTagName;
			onModel.
	].

	^ aScripter syncContinue
]

{ #category : #'examples - instance creation' }
GtCreateBehaviorElementByScripterExamples >> scripterForClass [
	<gtExample>
	| aScripter |
	
	self cleanUp.
	aScripter := self scripter.
	aScripter substep: 'Initialize Class creator' do: [ :aStep | 
		aStep set 
			label: 'Set Class creator element UI';
			element: [ self behaviorCreatorForClass ] ].

	^ aScripter syncContinue
]

{ #category : #'examples - class creator' }
GtCreateBehaviorElementByScripterExamples >> typeNewClassNameForClass [
	<gtExample>
	| aScripter |

	aScripter := self checkDefaultCreatorForClass.
	
	aScripter substep: 'Type new class name' do: [ :aStep | 
		aStep click
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
	
		aStep check
			label: 'Check class name editor has focus';
			satisfies: [ :aNameEditor | aNameEditor hasFocus ];
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
			
		aStep check
			label: 'Check class name editor is readonly';
			satisfies: [ :aNameEditor | aNameEditor isReadOnly ];
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
			
		aStep keyClick: BlKeyboardKey return.
			
		aStep check
			label: 'Check class name editor is in editable mode';
			satisfies: [ :aNameEditor | aNameEditor isEditable ];
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
		
		aStep type
			text: self newClassName;
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
			
		aStep check
			label: 'Check typed new class name';
			value: [ :aNameEditor | aNameEditor text asString ] equals: self newClassName;
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
			
		aStep keyClick: BlKeyboardKey return.
		
		aStep check
			label: 'Check class name editor has focus';
			satisfies: [ :aNameEditor | aNameEditor hasFocus ];
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
			
		aStep check
			label: 'Check class name editor is readonly';
			satisfies: [ :aNameEditor | aNameEditor isReadOnly ];
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
			
		aStep keyClick: BlKeyboardKey escape.
		
		aStep check
			label: 'Check class name editor does not have focus';
			satisfies: [ :aNameEditor | aNameEditor hasFocus not ];
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
		
		aStep check
			label: 'Check save button is disabled';
			satisfies: [ :aButton | aButton isDisabled ];
			onChildNamed: GtCreateBehaviorElement saveButtonName ].

	^ aScripter syncContinue
]

{ #category : #'examples - class creator' }
GtCreateBehaviorElementByScripterExamples >> typeNewClassNamePackageForClass [
	<gtExample>
	| aScripter |

	aScripter := self typeNewClassNameForClass.
	
	aScripter substep: 'Type new package name' do: [ :aStep | 
		aStep click
			onChildNamed: GtCodeDefinition packageEditorName.
	
		aStep check
			label: 'Check package name editor has focus';
			satisfies: [ :aNameEditor | aNameEditor hasFocus ];
			onChildNamed: GtCodeDefinition packageEditorName.
			
		aStep check
			label: 'Check package name editor is readonly';
			satisfies: [ :aNameEditor | aNameEditor isReadOnly ];
			onChildNamed: GtCodeDefinition packageEditorName.
			
		aStep keyClick: BlKeyboardKey return.
			
		aStep check
			label: 'Check package name editor is in editable mode';
			satisfies: [ :aNameEditor | aNameEditor isEditable ];
			onChildNamed: GtCodeDefinition packageEditorName.
		
		aStep type
			text: self newPackageName;
			onChildNamed: GtCodeDefinition packageEditorName.
			
		aStep check
			label: 'Check typed new package name';
			value: [ :aNameEditor | aNameEditor text asString ] equals: self newPackageName;
			onChildNamed: GtCodeDefinition packageEditorName.
			
		aStep keyClick: BlKeyboardKey return.
		
		aStep check
			label: 'Check package name editor has focus';
			satisfies: [ :aNameEditor | aNameEditor hasFocus ];
			onChildNamed: GtCodeDefinition packageEditorName.
			
		aStep check
			label: 'Check package name editor is readonly';
			satisfies: [ :aNameEditor | aNameEditor isReadOnly ];
			onChildNamed: GtCodeDefinition packageEditorName.
			
		aStep keyClick: BlKeyboardKey escape.
		
		aStep check
			label: 'Check package name editor does not have focus';
			satisfies: [ :aNameEditor | aNameEditor hasFocus not ];
			onChildNamed: GtCodeDefinition packageEditorName.
		
		aStep check
			label: 'Check save button is enabled';
			satisfies: [ :aButton | aButton isEnabled ];
			onChildNamed: GtCreateBehaviorElement saveButtonName ].

	^ aScripter syncContinue
]

{ #category : #'examples - class creator' }
GtCreateBehaviorElementByScripterExamples >> typeNewClassNamePackageTagForClass [
	<gtExample>
	| aScripter |

	aScripter := self typeNewClassNamePackageForClass.
	
	aScripter substep: 'Type new tag name' do: [ :aStep | 
		aStep click
			onChildNamed: GtCodeDefinition tagEditorName.
	
		aStep check
			label: 'Check tag name editor has focus';
			satisfies: [ :aNameEditor | aNameEditor hasFocus ];
			onChildNamed: GtCodeDefinition tagEditorName.
			
		aStep check
			label: 'Check tag name editor is readonly';
			satisfies: [ :aNameEditor | aNameEditor isReadOnly ];
			onChildNamed: GtCodeDefinition tagEditorName.
			
		aStep keyClick: BlKeyboardKey return.
			
		aStep check
			label: 'Check tag name editor is in editable mode';
			satisfies: [ :aNameEditor | aNameEditor isEditable ];
			onChildNamed: GtCodeDefinition tagEditorName.
		
		aStep type
			text: self newTagName;
			onChildNamed: GtCodeDefinition tagEditorName.
			
		aStep check
			label: 'Check typed new tag name';
			value: [ :aNameEditor | aNameEditor text asString ] equals: self newTagName;
			onChildNamed: GtCodeDefinition tagEditorName.
			
		aStep keyClick: BlKeyboardKey return.
		
		aStep check
			label: 'Check tag name editor has focus';
			satisfies: [ :aNameEditor | aNameEditor hasFocus ];
			onChildNamed: GtCodeDefinition tagEditorName.
			
		aStep check
			label: 'Check tag name editor is readonly';
			satisfies: [ :aNameEditor | aNameEditor isReadOnly ];
			onChildNamed: GtCodeDefinition tagEditorName.
			
		aStep keyClick: BlKeyboardKey escape.
		
		aStep check
			label: 'Check tag name editor does not have focus';
			satisfies: [ :aNameEditor | aNameEditor hasFocus not ];
			onChildNamed: GtCodeDefinition tagEditorName.
		
		aStep check
			label: 'Check save button is enabled';
			satisfies: [ :aButton | aButton isEnabled ];
			onChildNamed: GtCreateBehaviorElement saveButtonName ].

	^ aScripter syncContinue
]

{ #category : #'examples - class creator' }
GtCreateBehaviorElementByScripterExamples >> typePackageNameForClass [
	<gtExample>
	| aScripter |

	aScripter := self checkDefaultCreatorForClass.
	
	aScripter substep: 'Type new class name' do: [ :aStep | 
		aStep click
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
	
		aStep check
			label: 'Check class name editor has focus';
			satisfies: [ :aNameEditor | aNameEditor hasFocus ];
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
			
		aStep check
			label: 'Check class name editor is readonly';
			satisfies: [ :aNameEditor | aNameEditor isReadOnly ];
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
			
		aStep keyClick: BlKeyboardKey return.
			
		aStep check
			label: 'Check class name editor is in editable mode';
			satisfies: [ :aNameEditor | aNameEditor isEditable ];
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
		
		aStep type
			text: self newClassName;
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
			
		aStep check
			label: 'Check typed new class name';
			value: [ :aNameEditor | aNameEditor text asString ] equals: self newClassName;
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
			
		aStep keyClick: BlKeyboardKey return.
		
		aStep check
			label: 'Check class name editor has focus';
			satisfies: [ :aNameEditor | aNameEditor hasFocus ];
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
			
		aStep check
			label: 'Check class name editor is readonly';
			satisfies: [ :aNameEditor | aNameEditor isReadOnly ];
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
			
		aStep keyClick: BlKeyboardKey escape.
		
		aStep check
			label: 'Check class name editor does not have focus';
			satisfies: [ :aNameEditor | aNameEditor hasFocus not ];
			onChildNamed: GtCodeDefinition behaviorNameEditorName.
		
		aStep check
			label: 'Check save button is enabled';
			satisfies: [ :aButton | aButton isEnabled not ];
			onChildNamed: GtCreateBehaviorElement saveButtonName ].

	^ aScripter syncContinue
]
