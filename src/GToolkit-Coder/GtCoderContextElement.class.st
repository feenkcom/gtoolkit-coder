Class {
	#name : #GtCoderContextElement,
	#superclass : #GtCoderMethodElement,
	#category : #'GToolkit-Coder-UI'
}

{ #category : #accessing }
GtCoderContextElement >> contentElement [
	| element sourceElement variablesElement |
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	sourceElement := super contentElement.
	element addChild: sourceElement.
	variablesElement := BrColumnedList new.
	variablesElement addEventHandler: (GtInspectorListToSelectHandler new transformation: [ :each | each last ]).
	variablesElement column
		title: 'Variable';
		stencil: [ :each | 
			BrLabel new
				look: (BrGlamorousLabelLook new foreground: Color black);
				text: each first asString;
				hMatchParent;
				vMatchParent ].
	variablesElement column
		title: 'Value';
		stencil: [ :each | 
			BrLabel new
				look: (BrGlamorousLabelLook new foreground: Color black);
				text: (each last printStringLimitedTo: 50);
				hMatchParent;
				vMatchParent ].
	variablesElement display: self variables.
	element addChild: variablesElement.
	^ element
]

{ #category : #accessing }
GtCoderContextElement >> variables [
	| vars |
	vars := OrderedCollection new.
	methodCoder tempNamesAndValuesDo: [ :name :value | vars add: {name. 'temporary'. value} ].
	methodCoder instanceVariableNamesAndValuesDo: [ :name :value | vars add: {name. 'instance'. value} ].
	vars sort: [ :a :b | a first < b first ].
	vars addFirst: {'self'. 'self'. methodCoder receiver}.
	methodCoder stackVariableNamesAndValuesDo: [ :name :value | vars add: {name. 'stack'. value} ].
	^ vars
]
