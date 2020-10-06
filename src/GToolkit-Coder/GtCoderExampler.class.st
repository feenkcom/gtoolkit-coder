"
I am an example executor.
I am used by ${class:GtCodersModel}$, see: ${method:Behavior>>#gtCoderMethodsFor:context:}$ for a usage.
"
Class {
	#name : #GtCoderExampler,
	#superclass : #Object,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Coder-Exampler'
}

{ #category : #'api - instance creation' }
GtCoderExampler class >> coder: aCoder [
	^ self new coder: aCoder
]

{ #category : #'private - enumeration' }
GtCoderExampler >> allExampleCodersDo: aBlock [
	"iterate all coders with examples"
	self subclassResponsibility
]

{ #category : #'private - enumeration' }
GtCoderExampler >> allExampleResultCodersDo: aBlock [
	self allExecutableExampleCodersDo: [ :eachCoder | 
		eachCoder exampleResult ifNotNil: [ 
			aBlock cull: eachCoder ] ]
]

{ #category : #'private - enumeration' }
GtCoderExampler >> allExecutableExampleCodersDo: aBlock [
	self allExampleCodersDo: [ :eachCoder | 
		eachCoder canExecuteExample ifTrue: [ 
			aBlock cull: eachCoder ] ]
]

{ #category : #'api - accessing' }
GtCoderExampler >> coder [
	<return: #GtCoderModel or: #GtCodersModel>
	^ coder
]

{ #category : #'api - initialization' }
GtCoderExampler >> coder: anObject [
	coder := anObject
]

{ #category : #'api - accessing' }
GtCoderExampler >> coderFor: aCompiledMethod [
	<return: #GtMethodCoder>
	^ self subclassResponsibility
]

{ #category : #'api - testing' }
GtCoderExampler >> hasErrorExamples [
	<return: #Boolean>
	self allExampleResultCodersDo: [ :eachCoder | 
		eachCoder exampleResult isError ifTrue: [ 
			^ true ] ].
	^ false
]

{ #category : #'api - testing' }
GtCoderExampler >> hasExamples [
	self allExampleResultCodersDo: [ ^ true ].
	^ false
]

{ #category : #'api - testing' }
GtCoderExampler >> hasFailureExamples [
	<return: #Boolean>
	self allExampleResultCodersDo: [ :eachCoder | 
		eachCoder exampleResult isFailure ifTrue: [ 
			^ true ] ].
	^ false
]

{ #category : #'api - testing' }
GtCoderExampler >> hasNotExecutedExamples [
	<return: #Boolean>
	self allExampleCodersDo: [ :eachCoder | 
		eachCoder exampleResult ifNil: [ 
			^ true ] ].
	^ false
]

{ #category : #'api - testing' }
GtCoderExampler >> hasSuccessExamples [
	<return: #Boolean>
	self allExampleResultCodersDo: [ :eachCoder | 
		eachCoder exampleResult isSuccess ifTrue: [ 
			^ true ] ].
	^ false
]

{ #category : #'api - accessing' }
GtCoderExampler >> numberOfAllExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self allExecutableExampleCodersDo: [ :eachCoder | 
		aTotal := aTotal + 1 ].
	^ aTotal
]

{ #category : #'api - accessing' }
GtCoderExampler >> numberOfErrorExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self allExecutableExampleCodersDo: [ :eachCoder | 
		eachCoder exampleResult isError ifTrue: [ 
			aTotal := aTotal + 1 ] ].
	^ aTotal
]

{ #category : #'api - accessing' }
GtCoderExampler >> numberOfFailureExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self allExecutableExampleCodersDo: [ :eachCoder | 
		eachCoder exampleResult isFailure ifTrue: [ 
			aTotal := aTotal + 1 ] ].
	^ aTotal
]

{ #category : #'api - accessing' }
GtCoderExampler >> numberOfNotExecutedExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self allExecutableExampleCodersDo: [ :eachCoder | 
		eachCoder exampleResult ifNil: [ 
			aTotal := aTotal + 1 ] ].
	^ aTotal
]

{ #category : #'api - accessing' }
GtCoderExampler >> numberOfSuccessExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self allExecutableExampleCodersDo: [ :eachCoder | 
		eachCoder exampleResult isSuccess ifTrue: [ 
			aTotal := aTotal + 1 ] ].
	^ aTotal
]

{ #category : #'api - execution' }
GtCoderExampler >> runExamples [
	self selectedExecutableExampleCodersDo: [ :eachCoder | 
		eachCoder isModified ifFalse: [ 
			eachCoder example run ] ]
]

{ #category : #'api - execution' }
GtCoderExampler >> runExamplesFrom: anElement [
	self runExamples. 
]

{ #category : #'private - enumeration' }
GtCoderExampler >> selectedExampleCodersDo: aBlock [
	"iterate selected coders with examples"
	self subclassResponsibility
]

{ #category : #'private - enumeration' }
GtCoderExampler >> selectedExampleResultCodersDo: aBlock [
	self selectedExecutableExampleCodersDo: [ :eachCoder | 
		eachCoder exampleResult ifNotNil: [ 
			aBlock cull: eachCoder ] ]
]

{ #category : #'private - enumeration' }
GtCoderExampler >> selectedExecutableExampleCodersDo: aBlock [
	self selectedExampleCodersDo: [ :eachCoder | 
		eachCoder canExecuteExample ifTrue: [ 
			aBlock cull: eachCoder ] ]
]
