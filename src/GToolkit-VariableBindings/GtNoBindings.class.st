Class {
	#name : #GtNoBindings,
	#superclass : #Object,
	#traits : 'GtBindingsTrait',
	#classTraits : 'GtBindingsTrait classTrait',
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'GToolkit-VariableBindings-Core'
}

{ #category : #cleanup }
GtNoBindings class >> cleanUp [
	self reset.
]

{ #category : #accessing }
GtNoBindings class >> reset [
	uniqueInstance := nil
]

{ #category : #accessing }
GtNoBindings class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #comparing }
GtNoBindings >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class
]

{ #category : #converting }
GtNoBindings >> asDictionary [
	<return: #Dictionary>
	^ Dictionary new
]

{ #category : #adding }
GtNoBindings >> at: aString put: anObject [ 
	"ignore by default"
]

{ #category : #binding }
GtNoBindings >> bindingOf: aSymbol [
	^ nil
]

{ #category : #binding }
GtNoBindings >> hasBindingOf: aSymbol [
	^ false
]

{ #category : #comparing }
GtNoBindings >> hash [
	^ self class hash
]

{ #category : #accessing }
GtNoBindings >> receiver [
	^ nil
]

{ #category : #accessing }
GtNoBindings >> receiverClass [
	^ self receiver class
]
