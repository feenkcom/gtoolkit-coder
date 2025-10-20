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
		'element'
	],
	#category : #'GToolkit-Coder-UI-Execution'
}

{ #category : #'api - instance creation' }
GtCoderCodeExecutor class >> compileIt [
	"Execute a code that creates or updates a class"

	^ self new compileIt
]

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
GtCoderCodeExecutor class >> doItAndGoAsynchronous [
	"Execute a code block asynchronously and display the execution result"
	
	^ self new doItAndGoAsynchronous
]

{ #category : #'api - instance creation' }
GtCoderCodeExecutor class >> doItAndGoSerialized [
	"Execute a code and display the execution result"
	^ self new doItAndGoSerialized
]

{ #category : #'api - instance creation' }
GtCoderCodeExecutor class >> doItAsynchronous [
	"Execute code asynchronously (and do not display the execution result)"
	^ self new doItAsynchronous
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
GtCoderCodeExecutor >> compileIt [
	"Execute a code that creates or updates a class"

	action := #compileIt
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
GtCoderCodeExecutor >> doItAndGoAsynchronous [
	"Execute a code block asynchronously and display the execution result"

	action := #doItAndGoAsynchronous
]

{ #category : #initialization }
GtCoderCodeExecutor >> doItAndGoSerialized [
	"Execute a code and display the execution result"

	action := #doItAndGoSerialized
]

{ #category : #initialization }
GtCoderCodeExecutor >> doItAsynchronous [
	"Execute code asynchronously (and do not display the execution result)"

	action := #doItAsynchronous
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

{ #category : #'api - execution' }
GtCoderCodeExecutor >> execute [
	^ GtCoderExecutionContextVariable
		element: self element
		do: [
			self coderViewModel perform: action ]
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
