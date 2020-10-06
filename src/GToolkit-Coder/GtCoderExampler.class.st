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

{ #category : #'private - enumeration' }
GtCoderExampler >> exampleCodersDo: aBlock [
	"iterate all coders with examples"
	self subclassResponsibility
]

{ #category : #'private - enumeration' }
GtCoderExampler >> exampleResultCodersDo: aBlock [
	self executableExampleCodersDo: [ :eachCoder | 
			eachCoder exampleResult ifNotNil: [ 
				aBlock cull: eachCoder ] ]
]

{ #category : #'private - enumeration' }
GtCoderExampler >> executableExampleCodersDo: aBlock [
	self exampleCodersDo: [ :eachCoder | 
			eachCoder canExecuteExample ifTrue: [ 
				aBlock cull: eachCoder ] ]
]

{ #category : #'api - testing' }
GtCoderExampler >> hasExamples [
	self exampleCodersDo: [ ^ true ].
	^ false
]

{ #category : #'api - accessing' }
GtCoderExampler >> numberOfAllExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self executableExampleCodersDo: [ :eachCoder | 
		aTotal := aTotal + 1 ].
	^ aTotal
]

{ #category : #'api - accessing' }
GtCoderExampler >> numberOfErrorExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self exampleResultCodersDo: [ :eachCoder | 
		eachCoder exampleResult isError ifTrue: [ 
			aTotal := aTotal + 1 ] ].
	^ aTotal
]

{ #category : #'api - accessing' }
GtCoderExampler >> numberOfFailureExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self exampleResultCodersDo: [ :eachCoder | 
		eachCoder exampleResult isFailure ifTrue: [ 
			aTotal := aTotal + 1 ] ].
	^ aTotal
]

{ #category : #'api - accessing' }
GtCoderExampler >> numberOfNotExecutedExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self executableExampleCodersDo: [ :eachCoder | 
		eachCoder exampleResult ifNil: [ 
			aTotal := aTotal + 1 ] ].
	^ aTotal
]

{ #category : #'api - accessing' }
GtCoderExampler >> numberOfSuccessExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self exampleResultCodersDo: [ :eachCoder | 
		eachCoder exampleResult isSuccess ifTrue: [ 
			aTotal := aTotal + 1 ] ].
	^ aTotal
]

{ #category : #'api - execution' }
GtCoderExampler >> runExamples [
	self executableExampleCodersDo: [ :eachCoder | 
		eachCoder isModified ifFalse: [ 
			eachCoder example run ] ]
]

{ #category : #'api - execution' }
GtCoderExampler >> runExamplesFrom: anElement [
	self runExamples. 
]
