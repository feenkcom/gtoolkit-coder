Class {
	#name : #GtCoderMethodBodyElement,
	#superclass : #BlElement,
	#instVars : [
		'methodCoder',
		'toolbar'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #initialization }
GtCoderMethodBodyElement >> initialize [
	super initialize.
	
	toolbar := BrToolbar new.
	toolbar look: BrToolbarLook new.
	toolbar layout: BlLinearLayout horizontal.
	toolbar constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	toolbar addItem: (BrButton new
		look: BrGlamorousButtonWithIconLook;
		label: 'Accept';
		icon: BrGlamorousIcons accept asElement).
	
	self addChild: toolbar
]

{ #category : #accessing }
GtCoderMethodBodyElement >> methodCoder [
	^ methodCoder
]

{ #category : #initialization }
GtCoderMethodBodyElement >> methodCoder: aMethodCoder [
	| aSourceEditor anEditorElemenet completionStrategy completionController |

	methodCoder := aMethodCoder.

	aSourceEditor := methodCoder sourceEditor.

	anEditorElemenet := self newEditorElement.
	anEditorElemenet editor: aSourceEditor.

	methodCoder addBodyShortcutsTo: anEditorElemenet.

	completionStrategy := methodCoder newCompletionStrategy.

	completionController := GtCompletionController on: anEditorElemenet strategy: completionStrategy.
	completionController install.

	self addChildFirst: anEditorElemenet
]

{ #category : #'instance creation' }
GtCoderMethodBodyElement >> newEditorElement [
	| anEditorElemenet |
	<return: #BrEditorElement>
	
	anEditorElemenet := BrEditorElement new.
	anEditorElemenet constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].
	
	^ anEditorElemenet
]
