Class {
	#name : #GtBehaviorDefinitionCoderByScripterExamples,
	#superclass : #GtCoderByScripterExamples,
	#category : #'GToolkit-Coder-Examples-By scripter'
}

{ #category : #'examples - setup' }
GtBehaviorDefinitionCoderByScripterExamples >> behaviorDefinitionCoderForBasicClass [
	<gtExample>

	^ GtBehaviorDefinitionCoder forBehavior: self targetClass
]

{ #category : #'examples - setup' }
GtBehaviorDefinitionCoderByScripterExamples >> behaviorDefinitionElement [
	<gtExample>
	| behaviorDefinitionCoder behaviorDefinitionElement |

	behaviorDefinitionCoder := self behaviorDefinitionCoderForBasicClass.
	behaviorDefinitionElement := behaviorDefinitionCoder asElement.

	^ behaviorDefinitionElement
]

{ #category : #examples }
GtBehaviorDefinitionCoderByScripterExamples >> behaviorDefinitionScripter [
	<gtExample>
	| aScripter |

	aScripter := self scripter.
	aScripter set 
		label: 'Initialize behavior definition element';
		element: [ self behaviorDefinitionElement ].

	^ aScripter syncContinue
]

{ #category : #examples }
GtBehaviorDefinitionCoderByScripterExamples >> behaviorDefinitionScripter_CollapsedByDefault [
	<gtExample>
	| aScripter |

	aScripter := self behaviorDefinitionScripter.
	aScripter check
		label: 'Check that behavior definition is collapsed by default';
		satisfies: [ :aHeaderElement | aHeaderElement isCollapsed ].

	^ aScripter syncContinue
]

{ #category : #examples }
GtBehaviorDefinitionCoderByScripterExamples >> behaviorDefinitionScripter_ExpandHeader [
	<gtExample>
	| aScripter |

	aScripter := self behaviorDefinitionScripter_CollapsedByDefault.
	aScripter substep: 'Expand behavior definition' do: [ :aStep |
		aStep click
			label: 'Click on expand element';
			onChildAt: 1.
		aStep wait forEmptySpaceTaskQueue.
		aStep check 
			label: 'Check behavior definition element is expanded';
			satisfies: [ :aBehaviorDefinition | aBehaviorDefinition isExpanded ] ].

	^ aScripter syncContinue
]

{ #category : #examples }
GtBehaviorDefinitionCoderByScripterExamples >> behaviorDefinitionScripter_ExpandHeader_CollapseHeader [
	<gtExample>
	| aScripter |

	aScripter := self behaviorDefinitionScripter_ExpandHeader.
	aScripter substep: 'Expand and collapse behavior definition' do: [ :aStep |
		aStep click
			label: 'Click on expand element';
			onChildAt: 1.
		aStep wait forEmptySpaceTaskQueue.
		aStep check
			label: 'Check behavior definition element is collapsed';
			satisfies: [ :aBehaviorDefinition | aBehaviorDefinition isCollapsed ] ].

	^ aScripter syncContinue
]

{ #category : #accessing }
GtBehaviorDefinitionCoderByScripterExamples >> targetClass [
	^ GtBehaviorCoderDummyBasicClass
]
