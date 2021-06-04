"
I {{gtMethod:GtCoderCodeExecutor>>#execute|label=#selector}} a Pharo code provided by {{gtClass:GtCoderUIModel}}.
If a code is selected, I execute the selection. If there is no selection, I execute all code:
- {{gtMethod:GtCoderCodeExecutor class>>#doIt}}
- {{gtMethod:GtCoderCodeExecutor class>>#doIt}}

"
Class {
	#name : #GtCoderCodeExecutor,
	#superclass : #Object,
	#instVars : [
		'coderUIModel',
		'event',
		'action'
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
	^ self coderUIModel coder
]

{ #category : #'api - accessing' }
GtCoderCodeExecutor >> coderUIModel [
	^ coderUIModel
]

{ #category : #'api - accessing' }
GtCoderCodeExecutor >> coderUIModel: anObject [
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

{ #category : #'private - accessing' }
GtCoderCodeExecutor >> element [
	^ self event currentTarget
]

{ #category : #'api - accessing' }
GtCoderCodeExecutor >> event [
	^ event
]

{ #category : #'api - accessing' }
GtCoderCodeExecutor >> event: anObject [
	event := anObject
]

{ #category : #'api - execution' }
GtCoderCodeExecutor >> execute [
	GtCoderExecutionContextVariable
		element: self element
		do: [ self coderUIModel perform: action ]
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
