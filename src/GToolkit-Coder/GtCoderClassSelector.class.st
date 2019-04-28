Class {
	#name : #GtCoderClassSelector,
	#superclass : #Announcer,
	#instVars : [
		'coder',
		'packageEditor',
		'classNameEditor',
		'inputEditor'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #elements }
GtCoderClassSelector >> asElement [
	| element inputElement packageCompleter |
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	inputElement := BrEditorElement new.
	inputElement padding: (BlInsets all: 5).
	inputElement margin: (BlInsets all: 1).
	inputElement editor: inputEditor.
	inputElement constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical fitContent ].
	inputElement border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1).
	self coder theClass ifNotNil: [ :aClass |
		inputEditor text: (aClass package name, '>', aClass name) asRopedText glamorousRegularFont ].
	packageCompleter := GtCompletionController 
		on: inputElement 
		strategy: GtCoderClassWithPackageCompletionStrategy new.
	packageCompleter install.
	packageCompleter announcer when: GtCompleterCompletionAccepted do: [ :event | 
		self changedClassName ].
	element addChild: inputElement.
	^ element
]

{ #category : #private }
GtCoderClassSelector >> changedClassName [
	| className class |
	className := self className.
	className ifNil: [ ^ nil ].
	class := Smalltalk at: className asSymbol ifAbsent: [ nil ].
	class isBehavior
		ifTrue: [ self coder displayClass: class ]
]

{ #category : #accessing }
GtCoderClassSelector >> className [ 
	| content contentParts |
	content := self inputEditor text asString.
	contentParts := content splitOn: '>'.
	^ contentParts size = 1 
		ifTrue: [ contentParts first ]
		ifFalse: [ contentParts second ]
]

{ #category : #accessing }
GtCoderClassSelector >> coder [
	^ coder
]

{ #category : #accessing }
GtCoderClassSelector >> coder: aCoder [
	coder := aCoder
]

{ #category : #'initialize-release' }
GtCoderClassSelector >> initialize [
	super initialize.
	inputEditor := BrTextEditor new text: '' asRopedText glamorousRegularFont
]

{ #category : #accessing }
GtCoderClassSelector >> inputEditor [
	^ inputEditor
]

{ #category : #elements }
GtCoderClassSelector >> updateClassStrategy: classStrategy [
	classStrategy packageSearchString: packageEditor text asString.
	classNameEditor deleter
		from: 0 to: classNameEditor text size;
		delete
]
