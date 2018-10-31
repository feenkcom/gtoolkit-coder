Class {
	#name : #GtCoderMethodBodyElement,
	#superclass : #BlElement,
	#instVars : [
		'methodCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #initialization }
GtCoderMethodBodyElement >> initialize [
	super initialize.

	self layout: BlLinearLayout vertical
]

{ #category : #accessing }
GtCoderMethodBodyElement >> methodCoder [
	^ methodCoder
]

{ #category : #initialization }
GtCoderMethodBodyElement >> methodCoder: aMethodCoder [
	| anEditorElemenet |

	methodCoder := aMethodCoder.

	anEditorElemenet := self newEditorElement.
	anEditorElemenet constraintsDo: [ :c | c maxHeight: 200 ].
	anEditorElemenet editor: methodCoder sourceEditor.

	methodCoder addBodyShortcutsTo: anEditorElemenet.

	(GtCompletionController
		on: anEditorElemenet
		strategy: methodCoder newCompletionStrategy) install.

	self addChild: anEditorElemenet as: #bodyEditor.
	self addChild: (GtCoderMethodActionsElement new methodCoder: aMethodCoder)
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
