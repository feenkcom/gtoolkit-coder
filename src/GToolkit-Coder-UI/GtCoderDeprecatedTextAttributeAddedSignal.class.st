Class {
	#name : #GtCoderDeprecatedTextAttributeAddedSignal,
	#superclass : #ContextStackSignal,
	#instVars : [
		'coderTextAttributes',
		'deprecatedAttribute'
	],
	#category : #'GToolkit-Coder-UI-Signals'
}

{ #category : #accessing }
GtCoderDeprecatedTextAttributeAddedSignal >> coderTextAttributes [
	^ coderTextAttributes
]

{ #category : #accessing }
GtCoderDeprecatedTextAttributeAddedSignal >> coderTextAttributes: anObject [
	coderTextAttributes := anObject
]

{ #category : #accessing }
GtCoderDeprecatedTextAttributeAddedSignal >> deprecatedAttribute [
	^ deprecatedAttribute
]

{ #category : #accessing }
GtCoderDeprecatedTextAttributeAddedSignal >> deprecatedAttribute: anObject [
	deprecatedAttribute := anObject
]

{ #category : #printing }
GtCoderDeprecatedTextAttributeAddedSignal >> printOneLineContentsOn: stream [
	stream
		nextPutAll: '! ';
		print: deprecatedAttribute;
		space
]
