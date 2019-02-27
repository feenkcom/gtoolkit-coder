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
	| element inputElement |
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	inputElement := BrEditorElement new.
	inputElement padding: (BlInsets all: 10).
	inputElement editor: inputEditor.
	inputElement constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical fitContent ].
	inputElement border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1).
	self coder theClass ifNotNil: [ :aClass |
		inputEditor text: (aClass package name, '>>', aClass name) asRopedText ].
	inputEditor
		when: BlKeyDownEvent do: [ :event | 
			event key = Character enter ifTrue: [ self changedClassName ] ].
	element addChild: inputElement.
	^ element
]

{ #category : #elements }
GtCoderClassSelector >> asElement2 [
	| element packageElement packageCompleter classElement classStrategy classCompleter |
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element background: (Color veryLightGray alpha: 0.5).
	packageElement := BrEditorElement new.
	packageElement padding: (BlInsets all: 10).
	packageElement width: 200.
	packageElement editor: packageEditor.
	packageCompleter := GtCompletionController on: packageElement strategy: GtPackagesCompletionStrategy new.
	packageCompleter install.
	classElement := BrEditorElement new.
	classElement padding: (BlInsets all: 10).
	classElement width: 200.
	classElement editor: classNameEditor.
	classStrategy := GtPackageClassesCompletionStrategy new.
	packageEditor
		when: BrTextEditorInsertedEvent do: [ :event | self updateClassStrategy: classStrategy ];
		when: BrTextEditorDeletedEvent do: [ :event | self updateClassStrategy: classStrategy ].
	classCompleter := GtCompletionController on: classElement strategy: classStrategy.
	classCompleter install.
	classNameEditor
		when: BrTextEditorInsertedEvent do: [ :event | self changedClassName ];
		when: BrTextEditorDeletedEvent do: [ :event | self changedClassName ].
	element addChild: ((BlTextElement text: 'Package:' asRopedText) padding: (BlInsets top: 13 left: 10 bottom: 10 right: 0)).
	element addChild: packageElement.
	element addChild: ((BlTextElement text: 'Class:' asRopedText) padding: (BlInsets top: 13 left: 10 bottom: 10 right: 0)).
	element addChild: classElement.
	^ element
]

{ #category : #private }
GtCoderClassSelector >> changedClassName [
	| class |
	class := Smalltalk at: self className asSymbol ifAbsent: [ nil ].
	class isBehavior
		ifTrue: [ self coder selectClass: class ]
]

{ #category : #accessing }
GtCoderClassSelector >> className [ 
	| content packageAndClassName |
	content := self inputEditor text asString.
	packageAndClassName := content splitOn: '>>'.
	^ packageAndClassName size = 2 
		ifTrue: [ packageAndClassName second ]
		ifFalse: [ nil ]
		
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
	inputEditor := BrTextEditor new
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
