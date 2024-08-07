"
I {{gtMethod:GtCoderCodeExecutor>>#execute|label=#selector}} a Pharo code provided by {{gtClass:GtPharoSourceCoderViewModel}}.
If a code is selected, I execute the selection. If there is no selection, I execute all code:
- {{gtMethod:GtCoderCodeExecutor class>>#doIt}}
- {{gtMethod:GtCoderCodeExecutor class>>#doIt}}

"
Class {
	#name : #GtCoderCodeExecutor,
	#superclass : #Object,
	#instVars : [
		'coderUIModel',
		'action',
		'element',
		'executionStrategy'
	],
	#category : #'GToolkit-Coder-UI-Execution'
}

{ #category : #'api - instance creation' }
GtCoderCodeExecutor class >> doIt [
	"Execute a code (and do not display the execution result)"
	^ self new doIt
]

{ #category : #'api - instance creation' }
GtCoderCodeExecutor class >> doItAndGo [
	"Execute a code and display the execution result"
	^ self new doItAndGo
]

{ #category : #'api - instance creation' }
GtCoderCodeExecutor class >> doItAndGoSerialized [
	"Execute a code and display the execution result"
	^ self new doItAndGoSerialized
]

{ #category : #'api - instance creation' }
GtCoderCodeExecutor class >> playAll [
	"Execute a method code (and do not display the execution result)"
	^ self new playAll
]

{ #category : #'api - instance creation' }
GtCoderCodeExecutor class >> playAllAndInspect [
	"Execute a method code and display the execution result"
	^ self new playAllAndInspect
]

{ #category : #'private - accessing' }
GtCoderCodeExecutor >> coder [
	^ self coderViewModel coder
]

{ #category : #'api - accessing' }
GtCoderCodeExecutor >> coderViewModel [
	^ coderUIModel
]

{ #category : #'api - accessing' }
GtCoderCodeExecutor >> coderViewModel: anObject [
	coderUIModel := anObject
]

{ #category : #initialization }
GtCoderCodeExecutor >> doIt [
	"Execute a code (and do not display the execution result)"

	action := #doIt
]

{ #category : #initialization }
GtCoderCodeExecutor >> doItAndGo [
	"Execute a code and display the execution result"

	action := #doItAndGo
]

{ #category : #initialization }
GtCoderCodeExecutor >> doItAndGoSerialized [
	"Execute a code and display the execution result"

	action := #doItAndGoSerialized
]

{ #category : #'api - accessing' }
GtCoderCodeExecutor >> element [
	^ element
]

{ #category : #accessing }
GtCoderCodeExecutor >> element: anElement [
	self
		assert: [ anElement isKindOf: BlElement ]
		description: [ 'A code executor must be created in a context of an element' ].

	element := anElement
]

{ #category : #'api - accessing' }
GtCoderCodeExecutor >> event [
	self flag: 'I should not keep events, but rather #element'.
	self halt.
	^ nil
]

{ #category : #'api - accessing' }
GtCoderCodeExecutor >> event: anObject [
	self halt.
	self flag: 'I should not receive events, but rather #element:'.
]

{ #category : #'api - execution' }
GtCoderCodeExecutor >> execute [
	GtCoderExecutionContextVariable
		element: self element
		do: [ | coderViewModel |
			coderViewModel := self coderViewModel.
			coderViewModel executionStrategy: executionStrategy.
			coderViewModel perform: action ]
]

{ #category : #accessing }
GtCoderCodeExecutor >> executionStrategy [
	^ executionStrategy
]

{ #category : #accessing }
GtCoderCodeExecutor >> executionStrategy: anObject [
	executionStrategy := anObject
]

{ #category : #initialization }
GtCoderCodeExecutor >> initialize [
	super initialize.

	self doItAndGo.
]

{ #category : #initialization }
GtCoderCodeExecutor >> playAll [
	"Execute a method code (and do not display the execution result)"

	action := #playAll
]

{ #category : #initialization }
GtCoderCodeExecutor >> playAllAndInspect [
	"Execute a method code and display the execution result"

	action := #playAllAndInspect
]
