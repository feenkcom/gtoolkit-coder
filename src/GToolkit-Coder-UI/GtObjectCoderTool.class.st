Class {
	#name : #GtObjectCoderTool,
	#superclass : #GtCoderTool,
	#instVars : [
		'object'
	],
	#category : 'GToolkit-Coder-UI-Tools'
}

{ #category : #'instance creation' }
GtObjectCoderTool class >> forObject: anObject [
	^ self new object: anObject
]

{ #category : #converting }
GtObjectCoderTool >> newCoder [
	^ GtCoderElement forObject: self object
]

{ #category : #accessing }
GtObjectCoderTool >> object [
	^ object
]

{ #category : #accessing }
GtObjectCoderTool >> object: anObject [
	object := anObject
]

{ #category : #'api - accessing' }
GtObjectCoderTool >> title [
	"Return an object name"

	<return: #String>
	^ [ self object gtDisplayString ]
		onErrorDo: [ :anError | 
			[ | anotherTitle |
			anotherTitle := self object className.

			'{1}{2}''s error: {3}'
				format: {anotherTitle first isVowel ifTrue: [ 'an ' ] ifFalse: [ 'a ' ].
						anotherTitle.
						anError gtDisplayString} ]
				onErrorDo: [ :anotherError | anError messageText ] ]
]
