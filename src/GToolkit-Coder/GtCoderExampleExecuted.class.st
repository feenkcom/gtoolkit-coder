"
I am announced when a Coder example is executed.
I am used by {{gtClass:GtPharoMethodCoder}}, see {{gtMethod:GtPharoMethodCoder>>#handleExampleExecuted:|expanded}}.


"
Class {
	#name : #GtCoderExampleExecuted,
	#superclass : #GtSourceCoderAnnouncement,
	#instVars : [
		'example'
	],
	#category : 'GToolkit-Coder-Event'
}

{ #category : #accessing }
GtCoderExampleExecuted >> example [
	<return: #GtExampleWithResult>
	^ example
]

{ #category : #accessing }
GtCoderExampleExecuted >> example: aGtExampleWithResult [
	self 
		assert: [ aGtExampleWithResult isNotNil ] 
		description: [ 'Example must be non-nil' ].
	example := aGtExampleWithResult
]

{ #category : #testing }
GtCoderExampleExecuted >> hasResult [
	<return: #Boolean>
	^ self example hasResult
]

{ #category : #accessing }
GtCoderExampleExecuted >> result [
	<return: #GtExampleResult>
	^ self example result
]

{ #category : #accessing }
GtCoderExampleExecuted >> returnValue [
	^ self example returnValue
]
