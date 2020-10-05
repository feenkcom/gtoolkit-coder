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

{ #category : #'private - accessing' }
GtCoderExampler >> exampleCodersDo: aBlock [
	"iterate all coders with examples"
	self subclassResponsibility
]

{ #category : #'api - testing' }
GtCoderExampler >> hasExamples [
	self exampleCodersDo: [ ^ true ].
	^ false
]

{ #category : #'api - execution' }
GtCoderExampler >> runExamples [
	self exampleCodersDo: [ :eachCoder | 
		eachCoder isModified ifFalse: [ 
			eachCoder example run ] ]
]

{ #category : #'api - execution' }
GtCoderExampler >> runExamplesFrom: anElement [
	self runExamples. 
]
