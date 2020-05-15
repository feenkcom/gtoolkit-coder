Class {
	#name : #GtClassCoderTool,
	#superclass : #GtCoderTool,
	#category : #'GToolkit-Coder-Adaptors'
}

{ #category : #converting }
GtClassCoderTool >> newCoderFor: anObject [
	^ GtCoder forClass: anObject
]
