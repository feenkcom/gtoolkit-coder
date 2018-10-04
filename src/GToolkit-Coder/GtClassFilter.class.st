Class {
	#name : #GtClassFilter,
	#superclass : #Announcer,
	#instVars : [
		'packageEditor',
		'classNameEditor'
	],
	#category : #'GToolkit-Coder'
}

{ #category : #elements }
GtClassFilter >> asElement [
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
GtClassFilter >> changedClassName [
	| class |
	class := Smalltalk at: classNameEditor text asString asSymbol ifAbsent: [ nil ].
	class isBehavior
		ifTrue: [ self announce: (GtClassFilterAnnouncement forClass: class) ]
]

{ #category : #'initialize-release' }
GtClassFilter >> initialize [
	| packageCompleter |
	super initialize.
	packageEditor := BrTextEditor new.
	classNameEditor := BrTextEditor new
]

{ #category : #elements }
GtClassFilter >> updateClassStrategy: classStrategy [
	classStrategy packageSearchString: packageEditor text asString.
	classNameEditor deleter
		from: 0 to: classNameEditor text size;
		delete
]
