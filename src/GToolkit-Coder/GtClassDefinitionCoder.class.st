Class {
	#name : #GtClassDefinitionCoder,
	#superclass : #Announcer,
	#instVars : [
		'object',
		'class'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #'instance creation' }
GtClassDefinitionCoder class >> forClass: aBehavior [
	^ self new
		forClass: aBehavior;
		yourself
]

{ #category : #'instance creation' }
GtClassDefinitionCoder class >> forObject: anObject [
	^ (self forClass: anObject class)
		object: anObject;
		yourself
]

{ #category : #elements }
GtClassDefinitionCoder >> asElement [
	| element text classLabelElement |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	text := (String
		streamContents: [ :stream | 
			stream nextPutAll: class name.
			class superclass notNil
				ifTrue: [ stream
						nextPutAll: ' » ';
						nextPutAll: class superclass name ].
			class traits
				do: [ :each | 
					stream
						nextPutAll: ' + ';
						nextPutAll: each name ] ]) asRopedText.
	classLabelElement := BlTextElement text: text.
	classLabelElement
		padding:
			(BlInsets
				top: 10
				left: 10
				bottom: 10
				right: -10).
	classLabelElement border: (BlBorder paint: Color lightGray width: 1).
	classLabelElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element addChild: classLabelElement.
	element addChild: self variablesAndCommentElement.
	^ element
]

{ #category : #elements }
GtClassDefinitionCoder >> commentElement [
	| element |
	element := (Gt2Document forClass: class) asElement.
	element border: (BlBorder paint: Color lightGray width: 1).
	^ element
]

{ #category : #'initialize-release' }
GtClassDefinitionCoder >> forClass: aBehavior [
	class := aBehavior
]

{ #category : #'initialize-release' }
GtClassDefinitionCoder >> object: anObject [
	object := anObject
]

{ #category : #accessing }
GtClassDefinitionCoder >> theClass [
	^ class
]

{ #category : #elements }
GtClassDefinitionCoder >> variableElementNamed: aString type: aSymbol [
	| element nameElement dropDownElement |
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	nameElement := BlTextElement text: aString asRopedText.
	nameElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		margin: (BlInsets all: 10).
	element addChild: nameElement.
	
	dropDownElement := GtCoderDropdownStencil new
		allItems: #(instance class 'class instance');
		initialItem: aSymbol;
		asElement.
	
	dropDownElement constraintsDo: [ :c | c margin: (BlInsets all: 5) ].
	element addChild: dropDownElement.
	^ element
]

{ #category : #elements }
GtClassDefinitionCoder >> variablesAndCommentElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element addChild: self variablesElement.
	element addChild: self commentElement.
	^ element
]

{ #category : #elements }
GtClassDefinitionCoder >> variablesElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element border: (BlBorder paint: Color lightGray width: 1).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	class instVarNames do: [ :each | element addChild: (self variableElementNamed: each type: #instance) ].
	class classVarNames do: [ :each | element addChild: (self variableElementNamed: each type: #class) ].
	class isMeta
		ifFalse: [ class class instVarNames
				do: [ :each | element addChild: (self variableElementNamed: each type: 'class instance') ] ].
	^ element
]
