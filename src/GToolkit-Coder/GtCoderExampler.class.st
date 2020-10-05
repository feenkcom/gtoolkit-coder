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

{ #category : #'private - accessing' }
GtCoderExampler >> exampleCoders [
	<return: #Collection of: #GtMethodCoder>
	^ self subclassResponsibility
]

{ #category : #'api - testing' }
GtCoderExampler >> hasExamples [
	^ self exampleCoders isNotEmpty
]

{ #category : #'api - execution' }
GtCoderExampler >> runExamples [
	self exampleCoders do: [ :eachCoder | 
		eachCoder isModified ifFalse: [ 
			eachCoder example run ] ]
]

{ #category : #'api - execution' }
GtCoderExampler >> runExamplesFrom: anElement [
	self runExamples. 
]
