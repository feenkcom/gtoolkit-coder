Class {
	#name : #GtObjectCoderTool,
	#superclass : #GtCoderTool,
	#instVars : [
		'object'
	],
	#category : #'GToolkit-Coder-UI-Tools'
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
	^ object gtDisplayString
]
