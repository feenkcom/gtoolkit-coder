Class {
	#name : #GtCoderAction,
	#superclass : #Object,
	#instVars : [
		'title',
		'icon',
		'action',
		'id',
		'shortcutKey',
		'allowPrimaryClick',
		'allowAltClick',
		'actionDefinition',
		'isEnabled',
		'properties'
	],
	#category : #'GToolkit-Coder-Coders - Addons'
}

{ #category : #comparing }
GtCoderAction >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ id = anObject id and: [ title = anObject title ]
]

{ #category : #accessing }
GtCoderAction >> action [
	^ action
]

{ #category : #accessing }
GtCoderAction >> action: anObject [
	action := anObject
]

{ #category : #accessing }
GtCoderAction >> actionDefinition [
	"Return a method definition that defines the action"

	<return: #RBNode>
	^ actionDefinition
		ifNil: [ actionDefinition := self computeActionDefinition
					ifNil: [ GtCoderActionNoDefinition default ] ]
]

{ #category : #testing }
GtCoderAction >> allowAltClick [
	^ (allowAltClick ifNil: [ true ]) and: [ self actionDefinition isDefined ]
]

{ #category : #accessing }
GtCoderAction >> allowPrimaryClick [
	^ allowPrimaryClick ifNil: [ false ]
]

{ #category : #accessing }
GtCoderAction >> allowPrimaryClick: anObject [
	allowPrimaryClick := anObject
]

{ #category : #converting }
GtCoderAction >> asBrMenuItemForCoderElement: aTextualCoderEditorElement [
	^ nil
]

{ #category : #initialization }
GtCoderAction >> computeActionDefinition [
	^ self action isClosure
		ifTrue: [ GtCoderActionClosureDefinition new closure: self action ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
GtCoderAction >> disableAction [
	isEnabled := false
]

{ #category : #accessing }
GtCoderAction >> enableAction [
	isEnabled := true
]

{ #category : #evaluating }
GtCoderAction >> gtValueWithArgs: anArray [
	^ self action valueWithPossibleArgs: anArray
]

{ #category : #comparing }
GtCoderAction >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ id hash bitXor: title hash
]

{ #category : #accessing }
GtCoderAction >> hoverAction [
	^ nil
]

{ #category : #accessing }
GtCoderAction >> icon [
	^ icon
]

{ #category : #accessing }
GtCoderAction >> icon: anObject [
	icon := anObject
]

{ #category : #accessing }
GtCoderAction >> id [
	<return: #Object>
	
	^ id
]

{ #category : #accessing }
GtCoderAction >> id: anObject [
	id := anObject
]

{ #category : #testing }
GtCoderAction >> isDisabled [
	^ self isEnabled not 
]

{ #category : #testing }
GtCoderAction >> isEnabled [
	^ isEnabled ifNil: [ true ]
]

{ #category : #accessing }
GtCoderAction >> leaveAction [
	^ nil
]

{ #category : #accessing }
GtCoderAction >> name [
	^ id
]

{ #category : #accessing }
GtCoderAction >> name: anObject [
	id := anObject
]

{ #category : #printing }
GtCoderAction >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: (self title ifNil: ['']);
		nextPut: $)
]

{ #category : #'accessing properties' }
GtCoderAction >> properties [
	^ properties ifNil: [
		properties := Dictionary new ]
]

{ #category : #'accessing properties' }
GtCoderAction >> propertyAt: propName ifAbsent: aBlock [
	properties ifNil: [ ^aBlock value ].
	^ self properties
		at: propName
		ifAbsent: aBlock
]

{ #category : #'accessing properties' }
GtCoderAction >> propertyAt: propName put: propValue [
	^ self properties 
		at: propName
		ifAbsentPut: propValue
]

{ #category : #accessing }
GtCoderAction >> shortcutKey [

	^ shortcutKey ifNil: [shortcutKey := '']
]

{ #category : #accessing }
GtCoderAction >> shortcutKey: aString [

	shortcutKey := aString
]

{ #category : #accessing }
GtCoderAction >> title [
	^ title
]

{ #category : #accessing }
GtCoderAction >> title: anObject [
	title := anObject
]

{ #category : #evaluating }
GtCoderAction >> valueWithArguments: aSequenceOfArguments [
	^ self action valueWithArguments: aSequenceOfArguments
]
