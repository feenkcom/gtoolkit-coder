"
I ${method:GtCoderCodeExecutor>>#execute|label=#selector}$ a Pharo code provided by ${class:GtCoderUIModel}$.
If a code is selected, I execute the selection. If there is no selection, I execute all code:
- ${method:GtCoderCodeExecutor class>>#doIt}$
- ${method:GtCoderCodeExecutor class>>#doIt}$

"
Class {
	#name : #GtCoderCodeExecutor,
	#superclass : #Object,
	#instVars : [
		'coderUIModel',
		'event',
		'selectionAction',
		'allAction'
	],
	#category : #'GToolkit-Coder-Execution'
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
	allAction := #doItAll.
	selectionAction := #doIt:.
]

{ #category : #'private - execution' }
GtCoderCodeExecutor >> doItAll [
	self coder perform: allAction
]

{ #category : #initialization }
GtCoderCodeExecutor >> doItAndGo [
	"Execute a code and display the execution result"
	allAction := #doItAndGoAll.
	selectionAction := #doItAndGo:.
]

{ #category : #'private - execution' }
GtCoderCodeExecutor >> doItSelection: aBlock [
	self coder perform: selectionAction with: aBlock
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
		do: [ 
			| aSelection aText |
			aSelection := self coderUIModel selection.
			aText := self coderUIModel text.
			aSelection isNotEmpty
				ifTrue: [
					self doItSelection: [ :aSourceText |
						aText characters = aSourceText characters
							ifTrue: [ 
								| aMonoSelection |
								aMonoSelection := 1 to: 0.
								aSelection do: [ :eachMonotoneSelection | 
									aMonoSelection := eachMonotoneSelection from + 1 to: eachMonotoneSelection to ].
								aMonoSelection ]
							ifFalse: [
								"Text was modified"
								1 to: 0 ] ] ] 
				ifFalse: [ self doItAll ] ]
]

{ #category : #initialization }
GtCoderCodeExecutor >> initialize [
	super initialize.
	self doItAndGo.
]

{ #category : #initialization }
GtCoderCodeExecutor >> playAll [
	"Execute a method code (and do not display the execution result)"
	allAction := #playAll.
	selectionAction := #doIt:.
]

{ #category : #initialization }
GtCoderCodeExecutor >> playAllAndInspect [
	"Execute a method code and display the execution result"
	allAction := #playAllAndInspect.
	selectionAction := #doItAndGo:.
]
