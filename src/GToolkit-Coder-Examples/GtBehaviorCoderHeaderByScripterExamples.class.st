Class {
	#name : #GtBehaviorCoderHeaderByScripterExamples,
	#superclass : #GtCoderExamples,
	#category : #'GToolkit-Coder-Examples'
}

{ #category : #'examples - setup' }
GtBehaviorCoderHeaderByScripterExamples >> classCoderForBasicClass [
	<gtExample>
	^ GtClassCoder forClass: self targetClass.
]

{ #category : #'examples - setup' }
GtBehaviorCoderHeaderByScripterExamples >> coderHeaderElement [
	<gtExample>
	| classCoder coderHeaderElement |
	classCoder := self classCoderForBasicClass.
	coderHeaderElement := GtBehaviorCoderHeaderElement new classCoder: classCoder.

	self assert: coderHeaderElement classCoder theClass equals: self targetClass.
	^ coderHeaderElement
]

{ #category : #examples }
GtBehaviorCoderHeaderByScripterExamples >> coderHeaderScripter [
	<gtExample>
	| aScripter |
	aScripter := self scripter.
	aScripter set 
		label: 'Initialize Header Element';
		element: [ self coderHeaderElement ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #examples }
GtBehaviorCoderHeaderByScripterExamples >> coderHeaderScripter_CollapsedByDefault [
	<gtExample>
	| aScripter |
	aScripter := self coderHeaderScripter.
	aScripter check
		label: 'Check collapsed header';
		satisfies: [ :aHeaderElement | aHeaderElement isCollapsed ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #examples }
GtBehaviorCoderHeaderByScripterExamples >> coderHeaderScripter_ExpandHeader [
	<gtExample>
	| aScripter |
	aScripter := self coderHeaderScripter.
	aScripter substep: 'Expand header' do: [ :aStep |
		aStep click
			label: 'Click on expand element';
			onChildAt: 1.
		aStep wait forEmptySpaceTaskQueue.
		aStep check 
			label: 'Check header element is expanded';
			satisfies: [ :aHeaderElement | aHeaderElement isExpanded ] ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #examples }
GtBehaviorCoderHeaderByScripterExamples >> coderHeaderScripter_ExpandHeader_CollapseHeader [
	<gtExample>
	| aScripter |
	aScripter := self coderHeaderScripter_ExpandHeader.
	aScripter substep: 'Expand and collapse header' do: [ :aStep |
		aStep click
			label: 'Click on expand element';
			onChildAt: 1.
		aStep wait forEmptySpaceTaskQueue.
		aStep check 
			label: 'Check header element is collapsed';
			satisfies: [ :aHeaderElement | aHeaderElement isCollapsed ] ].
	aScripter syncContinue.
	^ aScripter
]

{ #category : #accessing }
GtBehaviorCoderHeaderByScripterExamples >> targetClass [
	^ GtBehaviorCoderDummyBasicClass
]
